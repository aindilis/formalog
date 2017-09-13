:- consult('/var/lib/myfrdcsa/codebases/minor/free-life-planner/lib/util/util.pl').

convertListToTerm([Head|Tail],Assertion) :-
	convertTailToListOfSubterms(Tail,Subterms),
	Assertion =.. [Head|Subterms].
convertListToTerm(Head,Head) :-
	atomic(Head).

convertTailToListOfSubterms(Tail,Subterms) :-
	findall(SubAssertion,getSubassertions(Tail,SubAssertion),Subterms),
	see([tail,Tail,subterms,Subterms]).

getSubassertions(Tail,SubAssertion) :-
	member(Item,Tail),
	convertListToTerm(Item,SubAssertion).

:- convertListToTerm([done,['page-read',andrewdo,['page-no','40',['publication-fn','README']]]],Assertion),see(Assertion).
