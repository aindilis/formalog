markPredicateDynamic(Context:Predicate/Arity) :-
	dynamic(Context:Predicate/Arity).

markPredicateDynamic(test:test/3).

:- assert(test:test(1,1,1)).
