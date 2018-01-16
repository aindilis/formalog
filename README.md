# formalog
Formalog is a backend for FRDCSA/Perl/Prolog integration, w/ persistence

http://frdcsa.org/frdcsa/minor/formalog

It does most of the work integrating Perl and Prolog, allowing using Language::Prolog::Yaswi calls back and forth.  This is for FCMS,
which is an MVC obtained by combining ShinyCMS (itself based on Perl Catalyst) with Formalog.  Add the initialization files for the 
Free Life Planner, or the Prolog-Agent, or the Formalog-KBFS, and you obtain those systems.

Formalog wraps UniLang, currently allowing it to call FreeKBS2 in order to assert into the KB.  However, we're working on a direct 
SWIPL ODBC interface which by lacking overhead should be many orders of magnitude faster.  This can be found in the data-integration 
codebase.
