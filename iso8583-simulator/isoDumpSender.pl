#!/usr/bin/perl

use IO::Socket::INET;

# flush after every write
$| = 1;

my $iso_file     = shift || q|iso-8583.hex.dump|;
my $remotePort    = shift || q|8085|;
my $remoteAddress = shift || q|127.0.0.1|;
my ( $socket, $client_socket );
my ( $peeraddress, $peerport );
my $data;
	
#Open file for reading
open IN, $iso_file  or die "Can't open $iso_file";
binmode IN;
# read in (up to) 64k chunks, write
read (IN, $data, 65536);
#Close file
close IN or die "Can't close $buffer";

# creating object interface of IO::Socket::INET and connect to remote host
$client_socket = new IO::Socket::INET (
    PeerHost => $remoteAddress,
    PeerPort => $remotePort,
    Proto => 'tcp'
    ) or die "ERROR in Socket Creation :".$!."\n";

printf ("Sending the request to: %s: %s\n", $remoteAddress, $remotePort);

#Send file's content
$client_socket->send($data);
print("The below data was sent:\n");
hexdump($data);

# Receive the response
my $accm;
while( $client_socket->recv($resp,1024) ){$accm.=$resp}

printf( qq!%s\nReceived %d bytes from %s :\n!, "="x72, length($resp), "$remoteAddress:$remotePort" );
hexdump($resp);

$client_socket->close();

#Dump string in HEX
sub hexdump {
    my $text = shift;
    my $addroffset = shift || 0; # optional
    my $n = shift || 20;
    my $pstr = q| |;
    my $addr = 0;

    # the extra awkward checks are to avoid warnings from substr
    until ($pstr eq "" || $addr>length($text) || !defined($pstr)) {
        $pstr = substr($text,$addr,$n);
        if (defined($pstr) && $pstr) {
           my $textaddr = sprintf "%08x", $addr + $addroffset;
           my $padl = 2 * ($n - length($pstr));
           my $texthex = join("", map { sprintf "%02x", $_ } unpack("C*",$pstr));
           my $pad =  " " x $padl;
           $pstr =~ s/[\x00-\x1f]/./g;
           $pstr =~ s/[\x7f-\xff]/./g;
           print "$textaddr: $texthex $pad $pstr\n";
        }
        $addr += $n;
    }
}
