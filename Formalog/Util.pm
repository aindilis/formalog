
sub DropPrologAnnotations {
  my ($self,%args) = @_;
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
	push @newlist, $self->DropPrologAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    } else {
      my @newlist;
      foreach my $subitem (@$item) {
	push @newlist, $self->DropPrologAnnotations(Interlingua => $subitem);
      }
      return \@newlist;
    }
  } else {
    return $item;
  }
}

sub MakeAllArraysAnnotatedPrologLists {
  my ($self,%args) = @_;
  my $item = $args{Interlingua};
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    my @newlist;
    foreach my $subitem (@$item) {
      push @newlist, $self->MakeAllArraysAnnotatedPrologLists(Interlingua => $subitem);
    }
    unshift @newlist, '_prolog_list';
    return \@newlist;
  } else {
    return $item;
  }
}

sub PrepareBindings {
  my ($self,%args) = @_;
  my $item = $args{Interlingua};
  my $depth = $args{Depth} || 1;
  my $ref = ref($item);
  print ClearDumper
    ({
      Ref => $ref,
      ArgsConversion => \%args,
     }) if $UNIVERSAL::debug;
  if ($ref eq 'ARRAY') {
    my @newlist;
    foreach my $subitem (@$item) {
      push @newlist, $self->PrepareBindings
	(
	 Interlingua => $subitem,
	 Depth => $depth + 1,
	);
    }
    unshift @newlist, '_prolog_list' if $depth < 5;
    return \@newlist;
  } else {
    return $item;
  }
}
