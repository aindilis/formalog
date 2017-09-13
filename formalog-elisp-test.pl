:- elispquery('(+ 1 1)',Result),
	clause_to_string(Result,String),
	write(String),
	nl.
