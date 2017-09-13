([retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[]]]][retval,[['Agent1','Yaswi1',1,[['temp-agent-0.470312081833498',[_G1529,completed(_G1529)]]]]]][ret,'temp-agent-0.470312081833498',[_G1529,completed(_G1529)]][retval,_G1618])

(figure out how to handle Receive callback since it won't
 necessarily have the formalogname associated with it.  I think
 the solution is to, hrm)

(
 sudo cpanm --reinstall --look Language::Prolog::Yaswi
 patch -p1 < /var/lib/myfrdcsa/codebases/minor/formalog/Language-Prolog-Yaswi-0.21-Adjust-list-parsing-to-SWI-Prolog-7.patch 
 export PERL_MM_OPT=
 perl Makefile.PL
 make
 make uninstall
 # manually clear out the entries
 make install
 # meet your uncle Bob
 )

(find-or-create a logic to describe relationships between load
 order and dependency of assertions in the KB.  For instance, if
 we assert something, and then assert a whole bunch more, we
 can't necessarily just retract it without breaking some stuff.
 have a logic for describing that.)

(add sorted ability.  maybe use extra field which points to the
 next item in the list, and maybe another field for previous
 item)

(add ability to load different contexts)

(see about having freekbs2 load vampire lazily, so it can do
 all-asserted-knowledge, etc quicker if at startup)

(can export dynamically prolog rules to files and consult them,
 and use the whole thing as an executable program spec in
 data (KB), for algorithm generation and analysis.)

(create an interactive command line program for interacting with
 flog)

(integrate prologmud)

(have the ability to set different contexts, and have the system
 know whether you can modify a certain context from a certain
 reasoner)

(create a unified interface foreach my $item (Q(cyc,'')) { },
 Q(pcyc,''), Q(formalog,''),Q(kbs2,''),Q(flora2,''),Q(all,'').  have
 standard persistence etc.  Create a generic persistence/reasoner
 object that works with different kinds of reasoners.  what does
 it look like from other languages? elisp, lisp, prolog, etc?)

(have the ability to do foreach my $item (fquery(['completed',Var('?X')])) { print Dumper($item) })

(A good thing to do would be to implement all of the various
 Yaswi interfaces.  then we can build stuff on top of that.)

(completed (get it so that it will do, depending on how you start it, both a
 swipl repl, and a unilang agent))

(doesn't appear to be a hook into assert.  ask Doug about this
 one maybe.  http://www.swi-prolog.org/man/hooks.html)

(Figure out how to do: fassert(:-(loves(X,Y),loves(Y,X))).)

(create a tool for putting new KBS2 contexts into a proper
 number-preserving lexicographical ordering, or other orders, to
 get them started.)

(implement retract etc)

(The system should periodically aggregate less often retracted
 predicates into a massive qlf file which loads at runtime.)

(Probably want to put something in so that if the KB changes, it
 updates the prolog program.  or it locks the KB while in use, or
 something.)

(Can do kassert as a wrapper around assert and asserta which
 nevertheless still uses regular assert to assert it.  when the
 program is loaded, it loads all the assertions this way.
 retract et all work the same way, and retract from both the
 persistence and the in memory version.  Keep them synchronized.)

(can use yaswi to get a list of all predicates, then load another
 module and have all of them defined in Yaswi)

