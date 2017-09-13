package Formalog::Multi;

use Formalog::Multi::Agent;

use Data::Dumper;

use Moose;

has Counter =>
  (
   is => "rw",
   isa => "Int",
   default => sub {0},
  );

has Agents =>
  (
   is => "rw",
   isa => "HashRef[Formalog::Multi::Agent]",
   default => sub {{}},
  );

sub AddNewAgent {
  my ($self,%args) = @_;
  my $agentname;
  if (exists $args{AgentName}) {
    $agentname = $args{AgentName};
  } else {
    $agentname = $self->GetNewAgentName();
  }
  if (! exists $self->Agents->{$agentname}) {
    $self->Agents->{$agentname} = Formalog::Multi::Agent->new
      (
       Multi => $self,
       AgentName => $args{AgentName},
       UniLangAgent => $args{UniLangAgent},
      );
    if (exists $args{YaswiName}) {
      $self->Agents->{$agentname}->AddNewYaswi
	(
	 AgentName => $agentname,
	 YaswiName => $args{YaswiName},
	 YaswiData => $args{YaswiData},
	);
    }
  } else {
    print "FIXME: throw an error that the agentname already exists\n";
  }
}

sub AddNewYaswiToAgent {
  my ($self,%args) = @_;
  if (exists $self->Agents->{$args{AgentName}}) {
    $self->Agents->{$args{AgentName}}->AddNewYaswi
      (
       AgentName => $args{AgentName},
       YaswiName => $args{YaswiName},
       YaswiData => $args{YaswiData},
      );
  } else {
    # FIXME: throw an error that the agent doesn't exist, or possibly
    # create the agent. probably the earlier

  }
}

# sub Execute {
#   my ($self,%args) = @_;
#   $self->Agents->{$args{AgentName}}->Execute();
# }

sub Execute {
  my ($self,%args) = @_;
  if (exists $self->Agents->{$args{AgentName}}) {
    $self->Agents->{$args{AgentName}}->Execute(%args);
  } else {
    print "FIXME: no agents found with that name\n";
  }
}

sub Query {
  my ($self,%args) = @_;
  if (exists $self->Agents->{$args{AgentName}}) {
    $self->Agents->{$args{AgentName}}->Query
      (
       YaswiName => $args{YaswiName},
       Message => $args{Message},
       Callback => $args{Callback},
      );
  } else {
    print "FIXME: no agents found with that name\n";
  }
}

1;

