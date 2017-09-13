#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

use Time::HiRes qw(gettimeofday);

my $date = [gettimeofday];
my $newtime = $date->[0] * 1000000 + $date->[1];
print Dumper($newtime);

my $timehires = join('',gettimeofday);
print Dumper($timehires);

