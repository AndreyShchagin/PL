use IO::Socket;
my $use_fork = 1;
 
my $sock = new IO::Socket::INET (
                                 LocalHost => '172.17.0.1',
                                 LocalPort => '9998',
                                 Proto => 'tcp',
                                 Listen => 1,   # maximum queued connections
                                 Reuse => 1,
                                )
	or die "socket: $!";	# no newline, so perl appends stuff
 
$SIG{CHLD} = 'IGNORE' if $use_fork;	# let perl deal with zombies
 
print "listening...\n";
while (1) {
    # declare $con 'my' so it's closed by parent every loop
        my $con = $sock->accept()
	or die "accept: $!";
    fork and next if $use_fork;	# following are for child only
 
    print "incoming..\n";
    print $con "Hello"; #read each line and write back
    print "done\n";
 
    last	if $use_fork;	# if not forking, loop
}