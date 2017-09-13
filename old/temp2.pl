#!/usr/bin/perl -w

use KBS2::ImportExport;
use PerlLib::SwissArmyKnife;

my $importexport = KBS2::ImportExport->new();

my $res = $importexport->Convert
  (
   Input => 'completed(_G1290).',
   InputType => 'Prolog',
   OutputType => "Interlingua",
  );

print Dumper({Res => $res});
