package Formalog::UniLangProxy;

# $UNIVERSAL::debug = 1;

use Formalog::Util::SWIPLI;
use KBS2::Client;
use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Agent::Agent;
use UniLang::Util::Message;

use Language::Prolog::Types qw(:util :ctors);
# use Language::Prolog::Yaswi ':query', ':load', ':interactive', ':run';
use Time::HiRes qw(gettimeofday);

use Moose;

has 'MyKBS2Client' =>
  (
   is => 'rw',
   isa => 'KBS2::Client',
  );

has 'MyImportExport' =>
  (
   is => 'rw',
   isa => 'KBS2::ImportExport',
   default => sub {
     KBS2::ImportExport->new();
   },
  );

has 'CycIsConnected' =>
  (
   is => 'rw',
   isa => 'Bool',
   default => 0,
  );

has 'Host' => (is => 'rw',isa => 'Str',default => "localhost");
has 'Port' => (is => 'rw',isa => 'Str',default => "9000");
has 'MessageQueue' =>
  (
   is => 'rw',
   isa => 'ArrayRef',
   default => sub {[]},
  );

sub BUILD {
  my ($self,$arglist) = @_;
  my %args = %$arglist;
  print Dumper({DoseArgs => \%args}) if $UNIVERSAL::Debug;
  if (! defined $UNIVERSAL::agents) {
    $UNIVERSAL::agents = {};
  }
  if (! exists $UNIVERSAL::agents->{$args{AgentName}}) {
    $UNIVERSAL::agentsData->{$args{AgentName}} = \%args;
    $UNIVERSAL::agents->{$args{AgentName}} = UniLang::Agent::Agent->new
      (
       Name => $args{AgentName},
       ReceiveHandler => sub {
	 my ($tmp,$message,@list) = @_;
	 $message->{Data}{_AgentName} = $args{AgentName};
	 $message->{Data}{_FormalogName} = $UNIVERSAL::agentsData->{$args{AgentName}}{FormalogName};
	 Receive(Message => $message, @list);
       },
      );
    $UNIVERSAL::formalogs = {};
  }


  $UNIVERSAL::agents->{$args{AgentName}}->DoNotDaemonize(1);
  $self->Host($args{Host}) if $args{Host};
  $self->Port($args{Port}) if $args{Port};
  $UNIVERSAL::agents->{$args{AgentName}}->Register
    (
     Host => $self->Host,
     Port => $self->Port,
     Properties => $args{Properties},
    );
  $UNIVERSAL::formalogs->{$args{FormalogName}} = $self;
}

sub Receive {
  my %args = @_;
  print "howdy do da\n";
  print Dumper({ReceiveMessage => $args{Message}}) if $UNIVERSAL::debug;
  my $agentname = $args{Message}{Data}{_AgentName};
  my $formalogname = $args{Message}{Data}{_FormalogName};
  $UNIVERSAL::formalogs->{$formalogname}->ProcessMessage
    (
     Message => $args{Message},
     AgentName => $agentname,
     FormalogName => $formalogname,
    );
}

sub Execute {
  my ($self,%args) = @_;
}

sub QueryAgent {
  my ($self,$agentname,$formalogname,@args) = @_;
  my $res = $UNIVERSAL::agents->{$agentname}->QueryAgent
    (
     Receiver => $args[0],
     Data => $args[1],
     Contents => $args[2] || "",
    );
  return $res;
}

sub QueryAgentSWIPL {
  my ($self,$agentname,$formalogname,@args) = @_;
  my $receiver = $self->SWIPLToInterlingua(SWIPL => $args[0]);
  my $args = {@{$self->DropPrologAnnotations
    (Interlingua => $self->SWIPLToInterlingua(SWIPL => $args[1]))}};
  my $tosend =
    {
     Receiver => $receiver,
     Data => $args,
    };
  if (defined $args[2]) {
    $tosend->{Contents} = $args[2];
  }
  print ClearDumper
    ({ToSend => $tosend}) if $UNIVERSAL::debug;
  my $res = $UNIVERSAL::agents->{$agentname}->QueryAgent
    (
     %$tosend
    );
  if (exists $res->{Data}) {
    print ClearDumper({Res => $res}) if $UNIVERSAL::debug;
    if (exists $res->{Data}{Result}) {
      my $ref = ref($res->{Data}{Result});
      if ($ref eq 'ARRAY') {
	unshift @{$res->{Data}{Result}}, '_prolog_list';
      }
      my $res2 = $self->InterlinguaToSWIPL
	(
	 Interlingua => ['_prolog_list',$res->{Data}{Result}],
	);
      return $res2;
    }
  } else {
    # FIXME: what to do now
  }
}

sub QueryAgentSWIPLPerl {
  my ($self,$agentname,$formalogname,@args) = @_;
  my $receiver = $self->SWIPLToInterlingua(SWIPL => $args[0]);
  # print Dumper({ArgsPre => $args[1]});
  my $interlingua = $self->SWIPLToInterlingua(SWIPL => $args[1]);
  # print Dumper({ArgsInterlingua => $interlingua});
  my $args = SWIPLIConvertPrologToPerl
    (Interlingua => $self->DropPrologAnnotations
     (
      Interlingua => $interlingua,
     ));
  # print Dumper({Args => $args});
  my $tosend =
    {
     Receiver => $receiver,
     Data => $args,
    };
  if (defined $args[2]) {
    $tosend->{Contents} = $args[2];
  }
  print ClearDumper
    ({ToSend => $tosend}) if $UNIVERSAL::debug;
  my $res = $UNIVERSAL::agents->{$agentname}->QueryAgent
    (
     %$tosend
    );
  if (exists $res->{Data}) {
    print ClearDumper({Res => $res}) if $UNIVERSAL::debug;
    if (exists $res->{Data}{Result}) {
      my $ref = ref($res->{Data}{Result});
      if ($ref eq 'ARRAY') {
	unshift @{$res->{Data}{Result}}, '_prolog_list';
      }
      my $res2 = $self->InterlinguaToSWIPL
	(
	 Interlingua => ['_prolog_list',$res->{Data}{Result}],
	);
      return $res2;
    }
  } else {
    # FIXME: what to do now
  }
}

sub sublQuery {
  my ($self,$agentname,$formalogname,@args) = @_;
  print ClearDumper({Args => [$agentname,$formalogname,\@args]}) if $UNIVERSAL::debug;
  if (0) {
    my $fh = IO::File->new();
    $fh->open(">>/tmp/wtf.txt");
    print $fh "sublQuery\n";
    print $fh ClearDumper
      ({
	Self => $self,
	Args => \@args,
       });
    $fh->close();
  }
  if (! $self->CycIsConnected) {
    my $res = $self->QueryAgent($agentname,$formalogname,'Org-FRDCSA-System-Cyc',{Connect => 1});
    if ($res->{Data}{Result} eq "connected") {
      $self->CycIsConnected(1);
    } else {
      # throw error
    }
  }
  if ($self->CycIsConnected) {
    my $res = $self->QueryAgent($agentname,$formalogname,'Org-FRDCSA-System-Cyc',{SubLQuery => $args[0]});
    my $res2 = $self->MakeAllArraysAnnotatedPrologLists(Interlingua => $res->{Data}{Result});
    my $res3 = $self->InterlinguaToSWIPL(Interlingua => $res2);
    return $res3;
  }
}

sub kbs2Query {
  my ($self,$agentname,$formalogname,@args) = @_;
  # $UNIVERSAL::debug = 1;
  if (! defined $self->MyKBS2Client) {
    $self->MyKBS2Client(KBS2::Client->new);
  }
  print ClearDumper({Args => \@args}) if $UNIVERSAL::debug;
  if ($args[0] eq 'assert') {
    my $res = $self->MyKBS2Client->Send
      (
       Assert => $args[1].'.',
       InputType => "Prolog",
       Context => $args[2],
       QueryAgent => 1,
       Flags => {
		 AssertWithoutCheckingConsistency => 1,
		},
      );
    print Dumper({ResMyMy => $res}) if $UNIVERSAL::debug;
    if (exists $res->{Data}) {
      if (exists $res->{Data}{Result}) {
	if (exists $res->{Data}{Result}{Success}) {
	  if ($res->{Data}{Result}{Success}) {
	    return [1,undef];
	  } else {
	    if (exists $res->{Data}{Result}{Reasons}) {
	      return [0,$res->{Data}{Result}{Reasons}];
	    }
	  }
	}
      }
    }
    return [0,undef];
  } elsif ($args[0] eq 'unassert') {
    # my $res = $self->MyKBS2Client->Send
    #   (
    #    Query => $args[1].'.',
    #    InputType => "Prolog",
    #    OutputType => "Interlingua",
    #    Context => $args[2],
    #    QueryAgent => 1,
    #    Flags => {
    # 		},
    #   );
    # my $res2 = $self->PrepareBindings(Interlingua => $res->{Data}{Result}{Bindings});
    # my $res3 = $self->InterlinguaToSWIPL(Interlingua => $res2);
    # return $res3;
  } elsif ($args[0] eq 'query') {
    my $res = $self->MyKBS2Client->Send
      (
       Query => $args[1].'.',
       InputType => "Prolog",
       OutputType => "Interlingua",
       Context => $args[2],
       QueryAgent => 1,
       Flags => {
    		},
      );
    my $res2 = $self->PrepareBindings(Interlingua => $res->{Data}{Result}{Bindings});
    my $res3 = $self->InterlinguaToSWIPL(Interlingua => $res2);
    return $res3;
  } elsif ($args[0] eq 'all-asserted-knowledge') {
    my $res = $self->MyKBS2Client->Send
      (
       QueryAgent => 1,
       Command => "all-asserted-knowledge",
       Context => $args[1],
      );
  }
}

sub kbs2QueryPrologInterlingua {
  my ($self,$agentname,$formalogname,@args) = @_;
  # print Dumper({Args => [$agentname,$formalogname,@args]});
  if (! defined $self->MyKBS2Client) {
    $self->MyKBS2Client(KBS2::Client->new);
  }
  print ClearDumper({Args => \@args}) if $UNIVERSAL::debug;
  if ($args[0] eq 'assert') {
    my @list = $self->SWIPLToInterlingua(SWIPL => $args[1]);
    print ClearDumper({List => \@list}) if $UNIVERSAL::debug;
    my $res = $self->MyKBS2Client->Send
      (
       Assert => [\@list],
       InputType => "Interlingua",
       Context => $args[2],
       QueryAgent => 1,
       Flags => {
		 AssertWithoutCheckingConsistency => 1,
		},
      );
    return $res->{Data}{Result};
  } elsif ($args[0] eq 'query') {
    my @list = $self->SWIPLToInterlingua(SWIPL => $args[1]);
    print ClearDumper({List => \@list}) if $UNIVERSAL::debug;
    my $res = $self->MyKBS2Client->Send
      (
       Query => [\@list],
       InputType => "Interlingua",
       OutputType => "Interlingua",
       Context => $args[2],
       QueryAgent => 1,
       Flags => {
    		},
      );
    my $res2 = $self->InterlinguaToSWIPL(Interlingua => $res->{Data}{Result}{Bindings});
    print ClearDumper({Res2 => $res2}) if $UNIVERSAL::debug;
    return $res2;
  } elsif ($args[0] eq 'all-asserted-knowledge') {
    my $res = $self->MyKBS2Client->Send
      (
       QueryAgent => 1,
       Command => "all-asserted-knowledge",
       Context => $args[1],
      );
  }
}

sub GetTime {
  my $date = [gettimeofday];
  return $date->[0] * 1000000 + $date->[1];
}

sub ListenAndReceive {
  my ($self,$agentname,$formalogname,%args) = @_;
  my $res1;
  my $timeout = 1.0; # 0.05;
  if (defined $UNIVERSAL::agent) {
    my $t0 = GetTime();
    my $t1;
    # FIXME: timeouts less than one cause it to loop constantly
    do {

      # FIXME: do we have to do anything with the return value of the
      # next call

      # FIXME: seems to work without this command
      $UNIVERSAL::agent->Listen(TimeOut => $timeout);

      # UniLang::Agent::Agent
      $res1 = $UNIVERSAL::agents->{$agentname}->Listen(TimeOut => $timeout);
      $t1 = GetTime();

      # print '.';
    } while ((($res1 == $timeout) or (! defined $res1)) and ($t1 < $t0 + 1000000));
    print "\n" if $UNIVERSAL::debug;
  } else {
    print "Agent <<<$agentname>>> listening\n";
    $res1 = $UNIVERSAL::agents->{$agentname}->Listen(TimeOut => $timeout);
  }
  my @res2 = @{$self->MessageQueue};
  # $UNIVERSAL::debug = 1;
  print ClearDumper({ListenAndReceiveArgs => [$res1,@res2]}) if $UNIVERSAL::debug;
  $self->MessageQueue([]);
  print Dumper([$agentname,$formalogname,$res1,\@res2]) if $UNIVERSAL::debug;
  return [$agentname,$formalogname,$res1,\@res2];
}

sub Evaluate {
  my ($self,%args) = @_;
  Dumper({'Evaluating...' => [$args{Receiver},$args{Evaluate}]});
  push @{$self->MessageQueue}, [$args{Receiver},$args{Evaluate}];
}

sub ProcessEvaluatedResult {
  my ($self,$agentname,$formalogname,@args) = @_;
  print Dumper({ProcessArgs => \@args}) if $UNIVERSAL::debug;
  my $res = $self->MyImportExport->Convert
    (
     Input => [$args[1]],
     InputType => 'SWIPL',
     OutputType => 'Interlingua',
    );
  if ($res->{Success}) {
    $UNIVERSAL::agents->{$agentname}->SendContents
      (
       Receiver => $args[0],
       Data => {
		_AgentName => $agentname,
		_FormalogName => $formalogname,
		Result => $res->{Output}[0],
	       },
      );
  } else {
    # FIXME: throw
  }
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  print ClearDumper({Message => $m});
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agents->{$args{AgentName}}->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agents->{$args{AgentName}}->Deregister;
      exit(0);
    }
  } else {
    my $d = $m->{Data};
    if (exists $d->{Eval}) {
      my $res = $self->MyImportExport->Convert
	(
	 Input => $d->{Eval},
	 InputType => 'Interlingua',
	 OutputType => 'SWIPL',
	);
      if ($res->{Success}) {
	$self->Evaluate
	  (
	   Receiver => $m->{Sender},
	   Evaluate => $res->{Output}[0],
	  );
      } else {
	# FIXME: throw
      }
    }
  }
}

sub SWIPLToInterlingua {
  my ($self,%args) = @_;
  my $res = $self->MyImportExport->Convert
    (
     Input => [$args{SWIPL}],
     InputType => 'SWIPL',
     OutputType => 'Interlingua',
    );
  print Dumper({ResSI => $res}) if $UNIVERSAL::debug;
  if ($res->{Success}) {
    return $res->{Output}[0];
  } else {
    # FIXME: throw
  }
}

sub InterlinguaToSWIPL {
  my ($self,%args) = @_;
  my $res = $self->MyImportExport->Convert
    (
     Input => [$args{Interlingua}],
     InputType => 'Interlingua',
     OutputType => 'SWIPL',
    );
  print Dumper({ResIS => $res}) if $UNIVERSAL::debug;
  if ($res->{Success}) {
    return $res->{Output}[0];
  } else {
    # FIXME: throw
  }
}

sub DropPrologAnnotations {
  my ($self,%args) = @_;
  my $item = $args{Interlingua};
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    if ($item->[0] eq '_prolog_list') {
      shift @$item;
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, $self->DropPrologAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    } else {
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, $self->DropPrologAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    }
  } else {
    return $item;
  }
}

sub MakeAllArraysAnnotatedPrologLists {
  my ($self,%args) = @_;
  my $item = $args{Interlingua};
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    my @newlist;
    foreach my $subitem (@$item) {
      push @newlist, $self->MakeAllArraysAnnotatedPrologLists(Interlingua => $subitem);
    }
    unshift @newlist, '_prolog_list';
    return \@newlist;
  } else {
    return $item;
  }
}

sub PrepareBindings {
  my ($self,%args) = @_;
  my $item = $args{Interlingua};
  my $depth = $args{Depth} || 1;
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    my @newlist;
    foreach my $subitem (@$item) {
      push @newlist, $self->PrepareBindings
	(
	 Interlingua => $subitem,
	 Depth => $depth + 1,
	);
    }
    unshift @newlist, '_prolog_list' if $depth < 5;
    return \@newlist;
  } else {
    return $item;
  }
}

1;
