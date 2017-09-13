package Formalog::Client;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(FormalogQuery);

use UniLang::Util::TempAgent;

{
  $tempagent = UniLang::Util::TempAgent->new();
}

sub FormalogQuery {
  my (%args) = @_;
  return $tempagent->MyAgent->QueryAgent
    (
     Receiver => $args{Agent} || 'Agent1',
     Data => {
	      Eval => [['_prolog_list',$args{Vars},$args{Query}]],
	     },
    );
}

1;
