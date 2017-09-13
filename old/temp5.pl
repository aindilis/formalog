% :- use_module(library(debug)).
% :- use_module(library(arithmetic)).
% :- use_module(library(memfile)).
% :- use_module(library(apply)).

% swipl -g 'Opts = [variable_names(_)],read_term(X,Opts), write_term(X,Opts).'

:- meta_predicate maplist(2, ?, ?).

print_list( [ ] ).
print_list( [ X | Y ] ):- nl, write('li: '), write(X), print_list( Y ).

maplist(_C_2, [], []).
maplist( C_2, [X|Xs], [Y|Ys]) :-
   call(C_2, X, Y),
   maplist( C_2, Xs, Ys).

trim_varname(Input,Output) :-
	with_output_to(string(I),write_term(Input,[quoted(true)])),
	atom_concat('_G',Tmp,I),
	atom_concat('Var_',Tmp,O),
	Output = =(O,I),
	write(Output).

kassert(Clause) :-
	term_variables(Clause, VarNames),
	maplist(trim_varname,VarNames,NewVarNames),
	write_term(Clause,[]),
	Opts = [variable_names([NewVarNames])],
	write_term(Clause,Opts).

start :-
	kassert(completed(Item)).

	% term_variables(completed(Item),List1)
	% term_to_string(,String),
	% print(String),nl.

% our_term_to_atom(T, Eqs, Atom) :-
%    with_output_to(atom(A), write_term(T,[variable_names(Eqs),quoted(true)]) ).

% our_term_to_string(Term,Atom) :-
% 	read_term(T,[variable_names(Eqs)]).
%         our_term_to_atom(T, Eqs, Atom),
% 	write(Atom).

% start2 :-
% 	our_term_to_string(completed(Item),String),
% 	print(String),nl.

% with_output_to(string(String), ).

% replace_variable_names(List1) :-
% 	member(Item1,List1),
% 	with_output_to(string(Item1String),write_term(Item1,[quoted(true)])),
% 	atom_concat('_G',Tmp,Item1String),
% 	atom_concat('VAR_',Tmp,Item2),
% 	atom_string(Item2,Item2String),
% 	assert(variableList(Item2String,Item1String)),
% 	fail.
% replace_variable_names(List1).



	% 
	% system:asserta(M:Clause, Ref),
	% asserta(names(Ref, VarTerm)).

% term_varnames(Term, VarNames, VarTerm) :-
% 	findall(Vars,
% 		( term_variables(Term, Vars),
% 		  bind_names(VarNames)
% 		),
% 		[ VarList ]),
% 	VarTerm =.. [ v | VarList ].

% bind_names([]).
% bind_names([Name=Var|T]) :-
% 	Name=Var,
% 	bind_names(T).
