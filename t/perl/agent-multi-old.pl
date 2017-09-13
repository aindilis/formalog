#!/usr/bin/perl -w

use Formalog::Multi;
use Formalog::Multi::External;
use UniLang::Agent::Agent;
use UniLang::Util::Message;

$UNIVERSAL::agent = UniLang::Agent::Agent->new
  (Name => "WSM",
   ReceiveHandler => \&Receive);
$UNIVERSAL::agent->DoNotDaemonize(1);

sub Receive {
  my %args = @_;
  print SeeDumper($args{Message});
}

TestSingleAgentWithSingleYaswiInternal();

#############

sub TestSingleAgentWithSingleYaswiInternal {
  my $multi = Formalog::Multi->new();
  $multi->AddNewAgent
    (
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
  $multi->Query
    (
     AgentName => 'Agent1',
     YaswiName => 'Yaswi1',
     QueryData => {
		   Query => 'true.',
		  },
    );
}
