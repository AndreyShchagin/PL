#!/usr/bin/perl
#tcpserver.pl

use IO::Socket::INET;

	# flush after every write
	$| = 1;

	my $localPort    = shift || q|9999|;
	my $localAddress = shift || q|127.0.0.1|;
	my ( $socket, $client_socket );
	my ( $peeraddress, $peerport );

	# creating object interface of IO::Socket::INET modules which internally does
	# socket creation, binding and listening at the specified port address.
	$socket = new IO::Socket::INET (
	LocalHost => $localAddress,
	LocalPort => $localPort,
	Proto => 'tcp',
	Listen => 5,
	Reuse => 1) or die "ERROR in Socket Creation :".$!."\n";

	printf ("SERVER Waiting for client connection on: %s:%s\n", $localAddress, $localPort);

        # waiting for new client connection.
	while($client_socket = $socket->accept())
	{
		# get the host and port number of newly connected client.
		$peer_address = $client_socket->peerhost();
		$peer_port = $client_socket->peerport();

		printf("Accepted New Client Connection From : %s, %s\n", $peer_address, $peer_port);

		# read operation on the newly accepted client
		#$data = <$client_socket>;
		while( ($aPort,$anAddr) = sockaddr_in($client_socket->recv($data,1024)) ){
			printf( qq!Received %d bytes from %s Client : %s\n!, length($data), "$anAddr:$aPort", $data ) if length($data) > 0;
			# write the responce.
			# $data ="DATA from Server";
			$client_socket->send($data);		 
		}
		printf("Send the responce: %s\n", $data);
	}

	$socket->close();