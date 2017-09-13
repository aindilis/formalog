#!/usr/bin/perl -w

use KBS2::ImportExport;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $importexport = KBS2::ImportExport->new();

my $res1 = $importexport->Convert
  (
   Input => [['_prolog_list', 'this','is',Var('?A'),'test']],
   InputType => 'Interlingua',
   OutputType => 'SWIPL',
  );

print Dumper({Result1 => $res1});

my $res2 = $importexport->Convert
  (
   Input => [$res1->{Output}[0]],
   InputType => 'SWIPL',
   OutputType => 'Interlingua',
  );

print Dumper({Result2 => $res2});
