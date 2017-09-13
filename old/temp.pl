#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

use Class::Inspector;
use Language::Prolog::Types qw(:util);

print Dumper(Class::Inspector->methods( 'Language::Prolog::Types::Internal::variable', 'full', 'public' ));
