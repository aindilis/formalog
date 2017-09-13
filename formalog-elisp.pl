elispquery(Query,Result) :-
	connectToUniLang(Connection),
	atom_concat('eval ',Query,String),
	perl5_method(Connection,'QueryAgentSWIPL',['Emacs-Client',['_DoNotLog','1'],String],[[Result]]).
