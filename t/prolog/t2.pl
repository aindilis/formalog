:- consult(formalog).

% kbs2Data('agent1-formalog1-context','Org::FRDCSA::Formalog::Test').

% test(sublQuery,AgentName,FormalogName) :-
% 	sublQuery(AgentName,FormalogName,['(cyc-assert (list #$isa (find-or-create-constant "Formalog-TheProgram") #$SoftwareAgent) #$BaseKB); '],Result1),
% 	sublQuery(AgentName,FormalogName,['(all-isa #$Formalog-TheProgram); '],Result2).

% test(kbs2QueryPrologInterlingua,AgentName,FormalogName) :-
% 	Context = 'Org::FRDCSA::Formalog::Test',
% 	kbs2QueryPrologInterlingua(AgentName,FormalogName,['assert',['p','X'],Context],Result2),
% 	kbs2QueryPrologInterlingua(AgentName,FormalogName,['assert',['p','Y'],Context],Result3).

test(kbs2Query,AgentName,FormalogName) :-
	kassert(AgentName,FormalogName,completed(task300),Result1),
	print('Result1: '),print(Result1),nl,
	kquery(AgentName,FormalogName,completed(Item),Result2),
	print('Result2: '),print(Result2),nl,
	kquery(AgentName,FormalogName,completed(temp),Result3),
	print('Result3: '),print(Result3),nl.


% test(completed,Input,Output) :-
% 	connectToUniLang(Connection),
% 	kassert(completed(Input),Output),

% test(maplist) :-
% 	maplist(test(completed),[1,2,3,4,5,6,7],Result).

start :-
	test(X,agent1,formalog1),
	fail.

:- start.