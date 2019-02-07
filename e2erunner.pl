#!/usr/bin/perl -w
use strict;

my @parameters = @ARGV;

foreach my $param (@parameters) {
    my $pid;
    next if $pid = fork;    # Parent goes to next server.
    die "fork failed: $!" unless defined $pid;

    # From here on, we're in the child.
    # exec - nver returns
    # system - returns
    print qx/protractor protractor.conf.js --parameters.login.email=$email --parameters.login.password=#password >$$.rep 2>&1/;
    
    exit;  # Ends the child process.
}

# The following waits until all child processes have
# finished, before allowing the parent to die.

1 while (wait() != -1);

print "All done!\n";
