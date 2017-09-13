#!/usr/bin/perl -w

use KBS2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

my $tempagent = UniLang::Util::TempAgent->new();

my $res = $tempagent->MyAgent->QueryAgent
  (
   Receiver => 'Test',
   Data => {
	    Command => 'queryInternalYaswi',
	    AgentName => 'Agent1',
	    YaswiName => 'Yaswi1',
	    QueryData => {
			  ThisIsATest => 1,
			 },
	   },
  );
print Dumper($res);
