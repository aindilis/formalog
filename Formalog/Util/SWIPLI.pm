package Formalog::Util::SWIPLI;

use PerlLib::SwissArmyKnife;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(SWIPLIGetHash SWIPLIGetList SWIPLIDropAnnotations
	     SWIPLIConvertPrologToPerl);

sub SWIPLIGetHash {
  my (%args) = @_;
  my @list = @{$args{Interlingua}};
  if ($list[0] eq '_prolog_list') {
    shift @list;
    my %hash = @list;
    return \%hash;
  }
}

sub SWIPLIGetList {
  my (%args) = @_;
  my @list = @{$args{Interlingua}};
  if ($list[0] eq '_prolog_list') {
    shift @list;
    return \@list;
  }
}

sub SWIPLIDropAnnotations {
  my (%args) = @_;
  my $item = $args{Interlingua};
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    if ($item->[0] eq '_prolog_list') {
      shift @$item;
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, SWIPLIDropAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    } else {
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, SWIPLIDropAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    }
  } else {
    return $item;
  }
}

sub SWIPLIConvertPrologToPerl {
  my (%args) = @_;
  my $item = $args{Interlingua};
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    if ($item->[0] eq '_prolog_list') {
      shift @$item;
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, SWIPLIConvertPrologToPerl(Interlingua => $subitem);
      }
      return \@newlist;
    } elsif ($item->[0] eq '_perl_hash') {
      shift @$item;
      my $hash = {};
      while (@$item) {
	my ($a,$b) = (shift @$item, shift @$item);
	$hash->{SWIPLIConvertPrologToPerl(Interlingua => $a)} = SWIPLIConvertPrologToPerl(Interlingua => $b);
      }
      return $hash;
    } else {
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, SWIPLIConvertPrologToPerl(Interlingua => $subitem);
      }
      return \@newlist;
    }
  } else {
    return $item;
  }
}

1;
