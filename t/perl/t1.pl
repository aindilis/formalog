#!/usr/bin/perl -w

use KBS2::Client;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

my $client = KBS2::Client->new;

my $res1 = $client->Send
  (
   QueryAgent => 1,
   Query => [["completed",Var('?X')]],
   InputType => "Interlingua",
   Context => 'Org::Cyc::BaseKB',
  );

print Dumper({Res1 => $res1});
