assert_list( [ ] ).
assert_list( [ X | Y ] ):- write('Asserting: '),write_term(X,[quoted(true)]),assert(X),nl,assert_list( Y ).

formalog_load_database(AgentName,FormalogName) :-
	kquery(AgentName,FormalogName,nil,Bindings),
	assert_list(Bindings).

formalog_init(AgentName,FormalogName) :-
	formalog_load_database(AgentName,FormalogName),
	formalog_toplevel(AgentName,FormalogName).

formalog_not_yet_implemented :-
				% called_by(Goal,Called),
	write('Function not yet implemented.'),nl,
				% throw(error()),
	true.

% fabolish(PredicateIndicator) :-
% 	formalog_not_yet_implemented.

% fabolish(Name,Arity) :-
% 	formalog_not_yet_implemented.

% fcopy_predicate_clauses(From,To) :-
% 	formalog_not_yet_implemented.

% fredefine_system_predicate(Head) :-
% 	formalog_not_yet_implemented.

% fretract(Term) :-
% 	formalog_not_yet_implemented.

%% fretractall(AgentName,FormalogName,Term) :-
%% 	kretractall(AgentName,FormalogName,Term),
%% 	retractall(Term).
	
%% fassertz(AgentName,FormalogName,Term,Result) :-
%% 	kassert(AgentName,FormalogName,Term,[[Result1,Error]]),
%% 	Result = [[Result1,Error]],
%% 	fassertz_handle(AgentName,FormalogName,Term,Result1,Error).

% fasserta(Term) :-
% 	formalog_not_yet_implemented.

fassertz(AgentName,FormalogName,Term,Result) :-
	kassert(AgentName,FormalogName,Term,[[Result1,Error]]),
	Result = [[Result1,Error]],
	fassertz_handle(AgentName,FormalogName,Term,Result1,Error).

fassertz_handle(AgentName,FormalogName,Term,Result,_) :-
	not(Result = 1),
	write('Could not assert value: '),write_canonical(Term),nl.
fassertz_handle(AgentName,FormalogName,Term,1,_) :-
	assert(Term).

fquery(AgentName,FormalogName,Term,Result) :-
	kquery(AgentName,FormalogName,Term,Result).

fassert(AgentName,FormalogName,Term,Result) :-
	fassertz(AgentName,FormalogName,Term,Result).

fassert_argt(AgentName,FormalogName,Arguments,Result) :-
	fassertz_argt(AgentName,FormalogName,Arguments,Result).

fassertz_argt(AgentName,FormalogName,Arguments,Result) :-
	kassert_argt(AgentName,FormalogName,Arguments,[[Result1,Error]]),
	Result = [[Result1,Error]],
	fassertz_handle(AgentName,FormalogName,Arguments,Result1,Error).

fassertz_handle_argt(AgentName,FormalogName,Term,Result,_) :-
	not(Result = 1),
	argt(Arguments,[term(Term)]),
	write('Could not assert value: '),write_canonical(Term),nl.
fassertz_handle_argt(AgentName,FormalogName,Arguments,1,_) :-
	argt(Arguments,[term(Term)]),
	assert(Term).


% fasserta(Term,Reference) :-
% 	formalog_not_yet_implemented.

% fassertz(Term,Reference) :-
% 	formalog_not_yet_implemented.

% fassert(Term,Reference) :-
% 	formalog_not_yet_implemented.

% frecorda(Key,Term,Reference) :-
% 	formalog_not_yet_implemented.

% frecorda(Key,Term) :-
% 	formalog_not_yet_implemented.

% frecordz(Key,Term,Reference) :-
% 	formalog_not_yet_implemented.

% frecordz(Key,Term) :-
% 	formalog_not_yet_implemented.

% frecorded(Key,Term,Reference) :-
% 	formalog_not_yet_implemented.

% frecorded(Key,Term) :-
% 	formalog_not_yet_implemented.

% ferase(Reference) :-
% 	formalog_not_yet_implemented.

% finstance(Reference,Term) :-
% 	formalog_not_yet_implemented.

% fflag(Key,Old,New) :-
% 	formalog_not_yet_implemented.

squelch(_) :-
	true.

:- consult(unilang).
:- consult('formalog-agent').
