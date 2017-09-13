#!/usr/bin/perl -w

use Formalog::Multi::Test;

use UniLang::Agent::Agent;
use UniLang::Util::Message;

$UNIVERSAL::agent = UniLang::Agent::Agent->new
  (Name => "Test",
   ReceiveHandler => \&Receive);
$UNIVERSAL::agent->DoNotDaemonize(1);

$UNIVERSAL::test = Formalog::Multi::Test->new();


sub Receive {
  my %args = @_;
  $UNIVERSAL::test->ProcessMessage
    (Message => $args{Message});
}

$UNIVERSAL::test->Execute();

