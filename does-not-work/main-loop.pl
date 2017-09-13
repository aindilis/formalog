:- module('$toplevel',
	  [ '$query_loop'/0,	% toplevel predicate
	    ]).

'$query_loop' :-
	(   current_prolog_flag(break_level, BreakLev)
	->  true
	;   BreakLev = -1
	),
	repeat,
	    (   '$module'(TypeIn, TypeIn),
		(   stream_property(user_input, tty(true))
		->  '$system_prompt'(TypeIn, BreakLev, Prompt),
		    prompt(Old, '|    ')
		;   Prompt = '',
		    prompt(Old, '')
		),
		trim_stacks,
		write('Yo rugman! '),nl,
		read_query(Prompt, Query, Bindings),
		prompt(_, Old),
		call_expand_query(Query, ExpandedQuery,
				  Bindings, ExpandedBindings)
	    ->  expand_goal(ExpandedQuery, Goal),
	        '$execute'(Goal, ExpandedBindings)
	    ), !.

:- consult(boot/toplevel).