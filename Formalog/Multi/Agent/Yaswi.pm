package Formalog::Multi::Agent::Yaswi;

use Formalog::Util::Prolog;
use PerlLib::SwissArmyKnife;

use Moose;

has Agent =>
  (
   is => "rw",
   isa => "Formalog::Multi::Agent",
   handles => ['AgentName'],
  );

has YaswiName =>
  (
   is => "rw",
   isa => "Str",
  );

has YaswiData =>
  (
   is => "rw",
   isa => "HashRef",
   default => sub {{}},
  );

has Prolog =>
  (
   is => "rw",
   isa => "Formalog::Util::Prolog",
   handles => ['Execute','Query'],
  );

sub BUILD {
  my ($self,$args) = @_;
  my %args = %$args;
  print Dumper({Args => \%args});
  my $context = shell_quote('Org::Cyc::BaseKB');
  my $filenametoload = '';
  if (scalar keys %{$self->YaswiData}) {
    if ($self->YaswiData->{Context}) {
      $context = shell_quote($self->YaswiData->{Context});
    }
    if ($self->YaswiData->{FileNameToLoad}) {
      $filenametoload = "consult('".shell_quote($self->YaswiData->{FileNameToLoad})."'),";
    }
  }
  # FIXME: properly quote agentname and yaswiname here
  my $myargs1 = "'".shell_quote($self->AgentName)."'".','."'".shell_quote($self->YaswiName)."'";
  my $myargs2 = [
		 '-nosignals',
		 '-g',

		 'consult(t/prolog/t1),'.
		 'setContext('.$myargs1.",'".$context."'),".
		 (exists $self->YaswiData->{Before} ? $self->YaswiData->{Before} : '').
		 'formalog_load_database('.$myargs1.'),'.
		 (exists $self->YaswiData->{During} ? $self->YaswiData->{During} : '').
		 $filenametoload.
		 (exists $self->YaswiData->{After} ? $self->YaswiData->{After} : 'true.'),
		 # 'formalog_toplevel('.$myargs1.').'),
		];
  print Dumper($myargs2);
  chdir "/var/lib/myfrdcsa/codebases/minor/formalog";
  $self->Prolog(Formalog::Util::Prolog->new
    (
     AgentName => $self->AgentName,
     YaswiName => $self->YaswiName,
     # YaswiData => $self->YaswiData,
     Args => $myargs2,
    ));
}

1;
