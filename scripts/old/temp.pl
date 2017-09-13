#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

my $tempagent = UniLang::Util::TempAgent->new(Name => "Formalog");

my $receiver = 'Org-FRDCSA-System-Cyc';
my @res1 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => $receiver,
   Data => {
	    Connect => 1,
	    CycArgs => {},
	   },
  );
print Dumper({Res1 => \@res1}) if $UNIVERSAL::debug;

my @res2 = $tempagent->MyAgent->QueryAgent
  (
   Receiver => $receiver,
   Data => {
	    SubLQuery => '(comment #$Researcher #$EverythingPSC)',
	   },
  );
print $res2[0]{Data}{Result}."\n";
