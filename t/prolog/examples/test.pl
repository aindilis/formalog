test :-
  Test is 1,
  catch(nb_getval(test,Test),_,true),
  write('writing'),nl,
  nb_setval(test,Test),
  write('written'),nl,
  catch(nb_getval(test,Test),_,false),
  write('gotten: '),write(Test),nl.
