package Formalog::Util::Prolog;

use strict;
use warnings;

BEGIN {
    require Language::Prolog::Yaswi::Low;
    @Language::Prolog::Yaswi::Low::args =
	($Language::Prolog::Yaswi::Low::args[0],
	 @ARGV)
}

use Data::Dumper;
use Language::Prolog::Yaswi qw(:query :run);
use Language::Prolog::Sugar
  functors => {
	       'formalog_listen' => 'formalog_listen',
	      },
  chains => {
	     # orn => ';',
	     # andn => 'andn',
	     # add => '+'
	    },
  vars => [qw(Connection)];


use Data::Dumper;
use Moose;

has AgentName =>
  (
   is => "rw",
   isa => "Str",
  );

has YaswiName =>
  (
   is => "rw",
   isa => "Str",
  );

has Queries =>
  (
   is => "rw",
   isa => "ArrayRef",
   default => sub {[]},
  );

sub BUILD {
  my ($self,$args) = @_;
  swi_init(@{$args->{Args}});
}

sub Execute {
  my ($self,%args) = @_;
  $Language::Prolog::Yaswi::swi_converter->pass_as_opaque('UNIVERSAL');
  my $method = 'new';
  if ($method eq 'old') {
    Language::Prolog::Yaswi::swi_toplevel;
  } elsif ($method eq 'new') {
    my $continue = 1;
    do {
      print "Hey\n" if $UNIVERSAL::debug;
      my $query;
      while ($query = shift @{$self->Queries}) {
	my $m = $query->{Message};
	# my $result = Language::Prolog::Yaswi::swi_call
	#   (
	#    formalog_listen($self->AgentName,$self->YaswiName,Connection)
	#   );
	my $result = ['tmp'];
	&{$query->{Callback}}
	  (
	   Message => $m,
	   Result => $result,
	  );
      }
      my $result2 = Language::Prolog::Yaswi::swi_call
	  (
	   formalog_listen($self->AgentName,$self->YaswiName,Connection)
	  );
      print Dumper({Result2 => $result2}) if $UNIVERSAL::debug;
    } while ($continue);
  }
}

sub Query {
   my ($self,%args) = @_;
   push @{$self->Queries}, \%args;
}

=head1 NAME

pl.pl - wrapper to call SWI-Prolog with perl embeded

=head1 SYNOPSIS

  $ pl.pl -q


=head1 ABSTRACT

Wrapper to run SWI-Prolog with support for calling perl


=head1 DESCRIPTION

Use this script in the same way that the pl executable from the SWI-Prolog
distribution.

Predicates perl5_call/3, perl5_eval/2 and perl5_method/4 will be
available from prolog.

=cut

1;
