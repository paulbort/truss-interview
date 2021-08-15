#!/bin/env perl

=head1 normalizer.pl

 normalizer.pl < input.csv > output.csv

CSV conversion utility for Truss interview process.

=cut

use feature "say";

# Core libraries:
use Encode qw(decode encode);
use Text::ParseWords;

# Additional libraries:
# use Date::Manip;

sub debug {
    my ( @msgs ) = @_;
    print STDERR "$_\n" foreach @msgs;
    return;
}

my $raw_input = join "\n", <>;
debug "STARTUP READ " . length( $raw_input ) . " characters";
my $raw_octets = decode('UTF-8', $raw_input, Encode::FB_DEFAULT);
# $raw_octets is now a bytestream of the input, with replacement character
my $csv = encode('UTF-8', $raw_octets, Encode::FB_CROAK); 
# $csv is now a real, clean UTF-8 string
debug "STARTUP CLEAN " . length( $csv ) . " characters";

my ( $header_line, @data_lines ) = split /\n+/, $csv;

say $header_line;

debug "STARTUP LINES " . @data_lines;
say process_line( $_ ) foreach @data_lines;


sub process_line {
    my ( $raw_line ) = @_;
    # debug "PROCESS IN: [$raw_line]";
    my @fields = quotewords( ',', 0, $raw_line );
    #debug "PROCESS FIELDS IN: [" . join( '][', @fields ) . ']';

    # 0: Timestamp: Convert to RFC3339, adjust PT to ET

    # 1: Address: No change
    $fields[1] = $fields[1];

    # 2: ZIP: Zero pad left
    return unless $fields[2] =~ /^\d{1,5}$/;
    $fields[2] = substr( '0000' . $fields[2], -5, 5 );

    # 3: FullName: uppercase w/non-latin support
    # 4: FooDuration: Convert to seconds
    # 5: BarDuration: Convert to seconds

    # 6: TotalDuration: Sum FooDuration and BarDuration
    #     (Presumed in the same format)
    $fields[6] = $fields[4] + $fields[5];

    # 7: Notes: No change
    $fields[7] = $fields[7];

    #debug "PROCESS FIELDS OUT: [" . join( '][', @fields ) . ']';
    my $result_line = join ',', @fields;
    #debug "PROCESS OUT: [$result_line]";
    return $result_line;
}
