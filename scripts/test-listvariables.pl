#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;
use KBS2::Util;

print Dumper(ListVariablesInFormula(Formula => ['a',\*{'::?item1'},['b',\*{'::?item2'}],\*{'::?item3'}]));
