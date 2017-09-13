package Formalog::Multi::External;

use KBS2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

use Moose;

my $tempagent = UniLang::Util::TempAgent->new(RandName => 'Formalog-Interact');

# FIXME: not nearly working yet, not sure if this is the right idioms

sub QueryExternal {
  my ($self,%args) = @_;
  my $res = $tempagent->MyAgent->QueryAgent
    (
     Receiver => $args{AgentName},
     Data => {
	      Eval => [['_prolog_list',Var('?X'),['completed',Var('?X')]]],
	     },
    );
  my $res2 = $res->{Data}{Result};
  print Dumper($res2);
}

1;
