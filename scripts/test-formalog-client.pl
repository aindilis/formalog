#!/usr/bin/perl -w

use Formalog::Client;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $res1 = FormalogQuery
  (
   Vars => ['_prolog_list',Var('?Results')],
   Query => ['allTermAssertions','meredithMcGhan',Var('?Results')],
  );

print Dumper($res1);
