#!/usr/bin/perl -w

use KBS2::Util;
use Task2::Util;
use PerlLib::SwissArmyKnife;
use UniLang::Util::TempAgent;

my $tempagent = UniLang::Util::TempAgent->new;

my $query = [["_prolog_list",["_prolog_list",Var('?Result')],["formalog_list_packages",Var('?Result')]]];
print Dumper($query);
my $message = 
  $tempagent->MyAgent->QueryAgent
  (Receiver => "Formalog",
   Data =>
   {
    _DoNotLog => 1,
    Eval => $query,
   });

my $list = $message->{Data}{Result}[1][1];
my $res = ProcessPackageList($list);
print Dumper($res);
