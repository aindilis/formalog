#!/usr/bin/perl -w

use KBS2::Client;
use PerlLib::SwissArmyKnife;




# FIXME: HOW TO DEAL WITH RETRACT / UNASSERT?




# ln -s /var/lib/myfrdcsa/codebases/minor/free-life-planner/data-git/systems/kbs2-updates /var/lib/myfrdcsa/codebases/minor/free-life-planner/frdcsa/sys/flp/autoload





# kbs2 -c Org::Cyc::BaseKB show

# my $exportdir = "";

# for each predicate, create a source file in the export dir named
# with that predicate, and append all instances (in prolog syntax).
# Also, mark them discontiguous, etc.

# then clear the assertions out of KBS2

# then load that dir into Formalog when starting.

my $client = KBS2::Client->new
  (
   Debug => 0,
   Method => "MySQL",
   Database => "freekbs2",
   Context => 'Org::Cyc::BaseKB',
  );

my $importexport = KBS2::ImportExport->new();

my $res1 = $client->Send
  (
   QueryAgent => 1,
   Command => 'all-asserted-knowledge',
   OutputType => 'Interlingua',
  );

my $timestamp = DateTimeStamp();
my $directoryroot = "/var/lib/myfrdcsa/codebases/minor/free-life-planner/frdcsa/sys/flp/autoload/kbs2-updates";
my $tmpdir = $directoryroot.'/'.$timestamp;
system 'mkdir -p '.shell_quote($tmpdir);

my $predicates = {};

foreach my $assertion (@{$res1->{Data}{Result}}) {
  # print Dumper($assertion);
  $predicate = $assertion->[0];
  $arity = (scalar @$assertion) - 1;
  if (! exists $predicates->{$predicate}) {
    $predicates->{$predicate} = {$arity => [$assertion]};
  } elsif (! exists $predicates->{$predicate}{$arity}) {
    $predicates->{$predicate}{$arity} = [$assertion];
  } else {
    push @{$predicates->{$predicate}{$arity}}, $assertion;
  }
}

foreach my $predicate (keys %$predicates) {
  foreach my $arity (keys %{$predicates->{$predicate}}) {
    my $filename = $tmpdir.'/'.$predicate.'-'.$arity.'.dat';
    my $fh = IO::File->new();
    $fh->open(">$filename");
    foreach my $assertion (sort {Dumper($a) cmp Dumper($b)} @{$predicates->{$predicate}{$arity}}) {
      my $res2 = $importexport->Convert
	(
	 Input => [$assertion],
	 InputType => 'Interlingua',
	 OutputType => 'Prolog',
	);
      if ($res2->{Success}) {
	print $fh $res2->{Output};
      } else {
	print STDERR Dumper({Res2 => $res2});
      }
    }
    $fh->close();
  }
}
