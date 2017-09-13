#!/usr/bin/perl -w

use Formalog::Multi;
# use Formalog::Multi::External;

# have it be able to start different external formalogs which are
# unilang clients, and each of those can start one or more internal
# formalogs.  they have a formalog name and a unilang name.

TestSingleAgentWithSingleYaswiInternal();
if (0) {
  TestSingleAgentWithMultipleYaswisInternal();
}

if (0) {
  TestSingleAgentWithSingleYaswiExternal();
  TestSingleAgentWithMultipleYaswisExternal();
  TestMultipleAgentsEachWithSingleYaswiExternal();
}

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

#############

sub TestSingleAgentWithMultipleYaswisInternal {
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

  # THIS IS THE ERROR: SWI-Prolog engine already initialised at
  # /usr/local/lib/x86_64-linux-gnu/perl/5.20.2/Language/Prolog/Yaswi/Low.pm
  # line 63.

  $multi->AddNewYaswiToAgent
    (
     AgentName => 'Agent1',
     YaswiName => 'Yaswi2',
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

#############

#############

sub TestSingleAgentWithSingleYaswiExternal {
  my $external = Formalog::Multi::External->new();
  $external->AddNewAgent
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
  $external->Query
    (
     AgentName => 'Agent1',
     YaswiName => 'Yaswi1',
     QueryData => {
		   Query => 'true.',
		  },
    );
}

#############

sub TestSingleAgentWithMultipleYaswisExternal {
  my $external = Formalog::Multi::External->new();
  $external->AddNewAgent
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
  $external->Query
    (
     AgentName => 'Agent1',
     YaswiName => 'Yaswi1',
     QueryData => {
		   Query => 'true.',
		  },
    );
}

#############

sub TestMultiAgentsWithMultiYaswis {
  $multi->AddNewAgent
    (

    );
  $multi->AddNewYaswiToAgent
    (

    );
  $multi->AddNewYaswiToAgent
    (

    );
  $multi->AddNewAgent
    (

    );
  $multi->AddNewYaswiToAgent
    (

    );
  $multi->AddNewYaswiToAgent
    (

    );
  $multi->YaswiQuery
    (
     Query => 'true.'
    );
}

sub TestMultipleAgentsEachWithSingleYaswiExternal {

}
