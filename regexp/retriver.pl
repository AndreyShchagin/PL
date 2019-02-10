#!/usr/bin/perl
use Data::Dumper;
use feature 'say';

my %hash = ();

while(<>){
 	$_ =~ /call\s+?(\w+?)[#]([^(]+?)\(/;
	if(!$hash{uc $1}){
		$hash{uc $1} = {lc $2,1};
	}else{
		$hash{uc $1}{lc $2}++;
	} 
}

#say Dumper(\%hash);
for(sort keys %hash){
	print $_." =>\n";
	for(sort keys %{$hash{$_}}){
		print "\t".$_."\n";
	}
}