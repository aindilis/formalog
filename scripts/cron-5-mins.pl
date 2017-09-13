#!/usr/bin/perl -w

use KBS2::ImportExport;
use KBS2::Util;
use Task2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

my $tempagent = UniLang::Util::TempAgent->new;
my $importexport = KBS2::ImportExport->new();

# this is the cron script to be run every five minutes.

# check if there are any reminders that must be sent.

# we could possibly have a window that it looks at, stored as a
# temporary assertion, which tells it the last time it checked.  then
# process all reminders in that time window.  Question: how do we deal
# with if the system is behind schedule.  what about when the system
# is started up after a while.

my $res1 = $importexport->Convert
  (
   Input => $input,
   InputType => 'Prolog',
   OutputType => 'Interlingua',
  );
if ($res1->{Success}) {
  my $interlingua = $res1->{Output}[0];
  my $variables = ListVariablesInFormula(Formula => $interlingua);
  unshift @$variables, '_prolog_list';
  my $query = [['_prolog_list',$variables,$interlingua]];

  my $res2 = $tempagent->MyAgent->QueryAgent
    (
     Receiver => "Agent1",
     Data => {
	      _DoNotLog => 1,
	      Eval => $query,
	     },
    );
  print Dumper($res2);
