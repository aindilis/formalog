#!/usr/bin/perl -w

use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $importexport = KBS2::ImportExport->new();
my $res1 = $importexport->Convert
  (
   Input => 'ask(oneOf(frdcsaAgentFn(akahige),Patient),Doctor,Communication).',
   InputType => 'Prolog',
   OutputType => 'Interlingua',
  );
if ($res1->{Success}) {
  my @query = @{$res1->{Output}};
  my @vars = ListVariablesInFormula(Formula => $res1->{Output});
  unshift @vars, '_prolog_list';
  print ClearDumper([[@vars,@query]]);
}


