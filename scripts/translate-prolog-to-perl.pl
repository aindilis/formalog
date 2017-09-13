#!/usr/bin/perl -w

use Formalog::Util::SWIPLI;
use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $importexport = KBS2::ImportExport->new();
my $res1 = $importexport->Convert
  (
   # Input => 'ask(\'_perl_hash\'(test1(x),test2(y))).',
   Input => 'ask(\'_perl_hash\'(test1,x,test2,y)).',
   InputType => 'Prolog',
   OutputType => 'Interlingua',
  );

if ($res1->{Success}) {
  print ClearDumper($res1);
  my $res2 = SWIPLIConvertPrologToPerl
    (
     Interlingua => $res1->{Output},
    );
  print ClearDumper($res2);
}



