#!/usr/bin/perl -w

use strict;
use warnings;
use POSIX qw(locale_h);
use locale;

setlocale(LC_CTYPE, "de_DE.UTF-8");
my $USAGE = "Usage: perl $0 <table-to-update-records-in> <file-to-parse.csv> <result-file.csv>\n";
my @COLUMN_NAMES = ("street_name","house_number");


scalar @ARGV == 3 or die scalar $USAGE;
my $table = $ARGV[0] or die $USAGE;
my $inputFile = $ARGV[1] or die $USAGE;
my $outputFile = $ARGV[2] or die $USAGE;

open(my $inputFh, '<:encoding(UTF-8)', $inputFile) or die "Could not open '$inputFile' $!\n";
open(my $outputFh, '>:encoding(UTF-8)', $outputFile) or die "Could not open 'result.csv' $!\n";

# skip header
readline $inputFh;

while (my $line = <$inputFh>) {
    chomp $line;
    chop($line) if ($line =~ m/\r$/);

    my @fields = split m/,/, $line;
    # Escape '
    $fields[1] =~ s/'/''/g;
    # Parse street and house
    $fields[1] =~ m/^(.*?)\s?([^0-9]+?)(\d+.*?)?$/gm or print STDERR "Wrong string: $fields[1]\n";

    print $2, defined $3 ? $3: defined $1 ? $1 : " ", "\n";

    printf $outputFh "UPDATE %s SET $_COLUMN_NAMES[0]='%s', $_COLUMN_NAMES[1]='%s' WHERE id='%s';\n", $table, $2,  defined $3 ? $3: defined $1 ? $1 : " ", $fields[0];
}

=pod

Parses CSV file, converts fields into insert query

Example:
id,street
b17f6a56427e,I'm Str. 9
0cdb2afc8c5,Ritchard Str. 85
4566548753514,Pelitzer Str. 5d7

Usage: perl migrateStreet.pl <table-to-update-records-in> <file-to-parse.csv> <result-file.cs

=cut
