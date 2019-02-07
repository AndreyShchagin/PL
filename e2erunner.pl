#!/usr/bin/perl -w
use strict;

my $executable = shift or die "Useage $0 PROTRACTOR ALLIAS";

while (<>) {
    my $pid;
    next if $pid = fork;    # Parent goes to next iteration
    die "fork failed: $!" unless defined $pid;

    # From here on, we're in the child.
    # exec - nver returns
    # system - returns
    my ($email, $password) = split /\s/,$_;
    print qq/Executing  $executable  --parameters.login.email=$email --parameters.login.password=$password as a new process\n/;
    print qx/$executable protractor.conf.js --parameters.login.email=$email --parameters.login.password=$password >$$.rep 2>&1/;
    
    exit;  # Ends the child process.
}

# The following waits until all child processes have
# finished, before allowing the parent to die.

1 while (wait() != -1);

print "All done!\n";

=pod

Runs multipple instances of a Protractor scripts at once - every instance as a separate process.
Can be usefull in order to simulate multipple-user behavious.
!!!Beware of a resource consumption. It was originally created to proof that Protractor is not a right tool for performance testing!!!

As an input it expects a tezt file with user credentials. Space separated, every user on a new line.
Example
user1@gmail.com password1
user2@gmail.com password2
user3@gmail.com password3
user4@gmail.com password4
user5@gmail.com password5

Pipe contents from the command line like:
cat credentials.txt | ./e2erunner.pl

=cut