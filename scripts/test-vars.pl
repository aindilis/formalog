#!/usr/bin/perl -w

use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $item = Var("Hello");
print Dumper($item);
my $ref = ref($item);
print Dumper($ref);
