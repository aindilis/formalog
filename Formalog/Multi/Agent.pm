package Formalog::Multi::Agent;

use Formalog::Multi::Agent::Yaswi;

use Data::Dumper;
use Moose;

has Multi =>
  (
   is => "rw",
   isa => "Formalog::Multi",
   handles => [],
  );

has AgentName =>
  (
   is => "rw",
   isa => "Str",
  );

has UniLangAgent =>
  (
   is => "rw",
   isa => "Any",
   handles => [],
  );

has Counter =>
  (
   is => "rw",
   isa => "Int",
   default => sub {0},
  );

has Yaswis =>
  (
   is => "rw",
   isa => "HashRef[Formalog::Multi::Agent::Yaswi]",
   default => sub {{}},
  );

sub AddNewYaswi {
  my ($self,%args) = @_;
  my $yaswiname;
  if (exists $args{YaswiName}) {
    $yaswiname = $args{YaswiName};
  } else {
    $yaswiname = $self->GetNewYaswiName();
  }
  if (! exists $self->Yaswis->{$yaswiname}) {
    print Dumper({AddNewYaswi => $yaswiname});
    $self->Yaswis->{$yaswiname} = Formalog::Multi::Agent::Yaswi->new
      (
       Agent => $self,
       YaswiName => $args{YaswiName},
       YaswiData => $args{YaswiData},
      );
  } else {
    print "FIXME: throw an error the yaswiname already exists\n";
  }
}

sub GetNewYaswiName {
  my ($self,%args) = @_;
  my $yaswiname;
  do {
    $yaswiname = 'Yaswi'.$self->Counter++;
  } while (exists $self->Yaswis->{$yaswiname});
  return $yaswiname;
}

sub Execute {
  my ($self,%args) = @_;
  if (exists $self->Yaswis->{$args{YaswiName}}) {
    $self->Yaswis->{$args{YaswiName}}->Execute(%args);
  }
}

sub Query {
  my ($self,%args) = @_;
  if (exists $self->Yaswis->{$args{YaswiName}}) {
    my $queryid = $self->Yaswis->{$args{YaswiName}}->Query
      (
       Message => $args{Message},
       Callback => $args{Callback},
      );
  } else {
    print "FIXME: no yaswis found with the name <<<$args{YaswiName}>>>.\n";
    print Dumper([keys %{$self->Yaswis}]);
  }
}

1;
