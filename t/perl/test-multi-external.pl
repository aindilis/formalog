#!/usr/bin/perl -w

use Formalog::Multi::External;

my $external = Formalog::Multi::External->new();
$external->QueryExternal
  (
   AgentName => 'Agent1',
  );
