package Formalog::Multi::Test;

use Formalog::Multi;
use Formalog::Multi::External;
use UniLang::Agent::Agent;
use UniLang::Util::Message;

use BOSS::Config;
use PerlLib::SwissArmyKnife;

use Moose;

has Config =>
  (
   is => 'rw',
   isa => 'BOSS::Config',
  );

has Multi =>
  (
   is => 'rw',
   isa => 'Formalog::Multi',
   default => sub {
     Formalog::Multi->new();
   },
  );

sub BUILD {
  my ($self,$args) = @_;

  my %args = %$args;
  my $specification = "
	-u [<host> <port>]	Run as a UniLang agent

	-w			Require user input before exiting
";
  # $UNIVERSAL::systemdir = ConcatDir(Dir("internal codebases"),"wsm");
  $self->Config
    (BOSS::Config->new
     (Spec => $specification,
      ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    # enter in to a listening loop
    my %addnewagentargs;
    if (exists $args{AddNewAgentArgs}) {
      %addnewagentargs = %{$args{AddNewAgentArgs}};
    } else {
      %addnewagentargs = (
			  AgentName => 'Agent1',
			  YaswiName => 'Yaswi1',
			  YaswiData => {
					# Context => '',
					# FileNameToLoad => '',
					# Before => '',
					# During => '',
					# After => '',
				       },
			 );
    }
    $self->Multi->AddNewAgent
      (
       %addnewagentargs,
      );
    if (exists $args{AddNewAgentArgs}) {
      $self->Multi->Execute
	(
	 AgentName => $args{AddNewAgentArgs}{AgentName},
	 YaswiName => $args{AddNewAgentArgs}{YaswiName},
	);
    } else {
      $self->Multi->Execute
      (
       AgentName => 'Agent1',
       YaswiName => 'Yaswi1',
      );
    }
  }
  if (exists $conf->{'-w'}) {
    Message(Message => "Press any key to quit...");
    my $t = <STDIN>;
  }
}

sub ReloadYaswi {
  my ($self,%args) = @_;
  # FIXME: implement a system to reload the contents of the Prolog system.

  # Also, have it have the ability to reconsult and individual file or
  # something like that, that has changed.  Also give it the ability
  # to, like the catalyst catalyst_server.pl script reload the
  # contents of the file if it has changed.
}

sub ProcessMessage {
  my ($self,%args) = @_;
  my $m = $args{Message};
  my $it = $m->Contents;
  if ($it) {
    if ($it =~ /^echo\s*(.*)/) {
      $UNIVERSAL::agent->SendContents
	(Contents => $1,
	 Receiver => $m->{Sender});
    } elsif ($it =~ /^(quit|exit)$/i) {
      $UNIVERSAL::agent->Deregister;
      exit(0);
    }
  }
  if (exists $m->{Data}{StartServer}) {
    # $self->StartServer();
    # $UNIVERSAL::agent->QueryAgentReply
    #   (
    #    Message => $m,
    #    Data => {
    # 		_DoNotLog => 1,
    # 		Result => 'started',
    # 	       },
    # 	);
  }
  if (exists $m->{Data}{Command}) {
    my $command = $m->{Data}{Command};
    if ($command eq 'queryInternalYaswi') {
      my $queryid = $self->Multi->Query
	(
	 AgentName => $m->{Data}{AgentName},
	 YaswiName => $m->{Data}{YaswiName},
	 Message => $m,
	 Callback => sub {
	   my (%args) = @_;
	   $UNIVERSAL::agent->QueryAgentReply
	     (
	      Message => $args{Message},
	      Data => {
		       _DoNotLog => 1,
		       Result => $args{Result},
		      },
	     );
	 },
	);
      # # UniLang::Agent::Agent
      # my $res = $UNIVERSAL::agent->QueryAgent
      # 	(
      # 	 Receiver => $m->{Data}{AgentName},
      # 	 Contents => 'echo hi',
      # 	);
      # $res = undef;
    } elsif ($command eq 'getCurrentState') {

    } elsif ($command eq 'reportLocation') {
      # which context is this?

      # context

      # metacontext information (accessibility relation, etc)

      # %{$m->{Data}{CommandArgs}};
    }
    if ($command eq 'restart') {
      my $res1 = $UNIVERSAL::agents->{Agent1}->SendContents
	(
	 Receiver => 'UniLang',
	 Contents => 'Deregister',
	);
      my $res2 = $UNIVERSAL::agent->SendContents
	(
	 Receiver => 'UniLang',
	 Contents => 'Deregister',
	);
      sleep 1;
      my $cli = GetCommandLineForCurrentProcess();
      system "(sleep 1; cd /var/lib/myfrdcsa/codebases/minor/formalog && $cli) &";
      exit(0);
    }
  }
}

1;
