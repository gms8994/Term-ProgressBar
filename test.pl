# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use Term::ProgressBar;
use POSIX qw<floor ceil>;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

my $count = 100;

# Test 2: create a bar
my $test_str = 'test';
my $b;
my $o = grab_output("\$b = new Term::ProgressBar '$test_str', $count");
if (not $b or $o->[0] ne '' or $o->[1] ne "$test_str: ") {
    print 'not ';
}
print "ok 2\n";

# Test 3: do half the stuff and check half the bar has printed
my $halfway = floor($count / 2);
$o = grab_output("update \$b foreach (0 .. $halfway - 1)");
if ($o->[0] ne ''
    or $o->[1] ne ('#' x floor($Term::ProgressBar::NUM_MARKS / 2)) )
{
    print 'not ';
}
print "ok 3\n";

# Test 4: do the rest of the stuff and check the whole bar has printed
$o = grab_output("update \$b foreach ($halfway .. $count - 1)");
if ($o->[0] ne ''
    or $o->[1] ne ('#' x ceil($Term::ProgressBar::NUM_MARKS / 2)) . "\n" )
{
    print 'not ';
}
print "ok 4\n";

# Test 5: try to do another item and check there is an error
eval { update $b };
print 'not '
  unless defined($@)
  and $@ =~ /^\Q$Term::ProgressBar::ALREADY_FINISHED\E/;
print "ok 5\n";


# grab_output()
# 
# Eval some code and return what was printed to stdout and stderr.
# 
# Parameters: string of code to eval
# 
# Returns: listref of [ stdout text, stderr text ]
# 
sub grab_output($) {
    die 'usage: grab_stderr(string to eval)' if @_ != 1;
    my $code = shift;
    require POSIX;
    my $tmp_o = POSIX::tmpnam(); my $tmp_e = POSIX::tmpnam();
    local *OLDOUT, *OLDERR;
    
    # Try to get a message to the outside world if we die
    local $SIG{__DIE__} = sub { print $_[0]; die $_[0] };

    open(OLDOUT, ">&STDOUT") or die "can't dup stdout: $!";
    open(OLDERR, ">&STDERR") or die "can't dup stderr: $!";
    open(STDOUT, ">$tmp_o")  or die "can't open stdout to $tmp_o: $!";
    open(STDERR, ">$tmp_e")  or die "can't open stderr to $tmp_e: $!";
    eval $code;
    # Doubtful whether most of these messages will ever be seen!
    close(STDOUT)            or die "cannot close stdout opened to $tmp_o: $!";
    close(STDERR)            or die "cannot close stderr opened to $tmp_e: $!";
    open(STDOUT, ">&OLDOUT") or die "can't dup stdout back again: $!";
    open(STDERR, ">&OLDERR") or die "can't dup stderr back again: $!";

    die $@ if $@;

    local $/ = undef;
    open (TMP_O, $tmp_o) or die "cannot open $tmp_o: $!";
    open (TMP_E, $tmp_e) or die "cannot open $tmp_e: $!";
    my $o = <TMP_O>; my $e = <TMP_E>;
    close TMP_O   or die "cannot close filehandle opened to $tmp_o: $!";
    close TMP_E   or die "cannot close filehandle opened to $tmp_e: $!";
    unlink $tmp_o or die "cannot unlink $tmp_o: $!";
    unlink $tmp_e or die "cannot unlink $tmp_e: $!";

    return [ $o, $e ];
}
