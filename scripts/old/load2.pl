:- perl5_eval('use PerlLib::SwissArmyKnife; use UniLang::Util::TempAgent; my $tempagent = UniLang::Util::TempAgent->new(Name => "Formalog"); my $receiver = \'Org-FRDCSA-System-Cyc\'; my @res1 = $tempagent->MyAgent->QueryAgent(Receiver => $receiver,Data => {Connect => 1,},); my @res2 = $tempagent->MyAgent->QueryAgent(Receiver => $receiver,Data => {SubLQuery => \'(comment #$Researcher #$EverythingPSC)\'}); return $res2[0]{Data}{Result};',X),print(X),nl.


% perl5_eval('$Language::Prolog::Yaswi::swi_converter \
%              -> pass_as_opaque("HTTP::Request")',_),
% perl5_eval('use HTTP::Request',_),
% perl5_method('HTTP::Request', new, [], [Request]),
% perl5_method(Request, as_string, [], [Text]).