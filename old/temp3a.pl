run(String) :-
	Opts	= [variable_names(['This' = _1735,'Nice' = _1809])],
	X	= f(_1735 is _1809),
	with_output_to(string(String),write_term(X,Opts)).

show :-
	run(String),
	write(String).
	
