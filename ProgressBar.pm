package Term::ProgressBar;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp;

$VERSION = '1.0';

# Configuration data.  test.pl looks at these but you shouldn't.
use vars qw<$NOTHING_TO_DO $ALREADY_FINISHED $NUM_MARKS>;
$NOTHING_TO_DO = '(nothing to do)';
$ALREADY_FINISHED = 'progress bar already finished';
$NUM_MARKS = 50;

=pod

=head1 NAME

Term::ProgressBar - Perl extension to display a progress bar

=head1 SYNOPSIS

  use Term::ProgressBar;
  my $num_items = 100;
  my $bar = new Term::Progressbar('working magic', $num_items);
  foreach (0 .. $num_items-1) {
      # do work for item $_
      update $bar;
  }

=head1 DESCRIPTION

This module provides a simple progress indicator for command line
programs.  You initialize a ProgressBar object with a brief
description of what is happening and the number of things that need
doing, and after each thing is done you call the object's update()
method.

At the moment, this is presented to the user (on stderr) as a sequence
of 50 hash marks (no matter how many things are being done).

=head1 METHODS

=over


=item C<new(desc, num_items)>

Create and return a new progress bar, which is displayed to the user.
Parameters are:

=over

=item C<desc> - descriptive name of what you're doing (eg 'working magic')

=item C<num_items> - total number of items which must be completed

=back

=cut
sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    die "usage: package->new(description, num of items)" if @_ != 2;
    my ($desc, $total) = @_;
    print STDERR "$desc: ";
    print STDERR "$NOTHING_TO_DO\n" if $total == 0;
    return bless [ 0, $total ], $class; # Zero items of $total done
}

=pod


=item C<update()>

Update the progress bar by one 'tick'.  You should call this after
completing each one of the 'items' included in the counter's total.
The progress bar will be updated accordingly (at present, this means
more text printed to stderr).

=cut
sub update {
    my $self = shift;
    croak $ALREADY_FINISHED if $self->[0] == $self->[1];

    # Find how many have been displayed so far.  Then increment the
    # count and find how many marks need to be displayed.  If
    # necessary, we then print some marks to the screen.
    # 
    my $so_far = int($NUM_MARKS * $self->[0] / $self->[1]);
    ++ ($self->[0]);
    my $needed = int($NUM_MARKS * $self->[0] / $self->[1]);
    print STDERR '#' x ($needed - $so_far);

    if ($self->[0] == $self->[1]) {
	# Finished.  Should have printed all the marks.
	die if $needed != $NUM_MARKS;
	print STDERR "\n";
    }
}

=pod

=head1 AUTHOR

Ed Avis, epa98@doc.ic.ac.uk

=head1 SEE ALSO

perl(1).

=cut

1;
__END__
