#!/bin/env perl

=head1 normalizer.pl

 normalizer.pl < input.csv > output.csv

CSV conversion utility for Truss interview process.

=cut

use feature ":5.32";

# Only use CORE libraries for best portability:
use Encode qw(decode encode);
use Text::ParseWords;

my $DEBUG = 1;

sub debug {
    my ( @msgs ) = @_;
    return if not $DEBUG;
    print STDERR "$_\n" foreach @msgs;
    return;
}

my $raw_input = join "\n", <>;
debug "STARTUP READ " . length( $raw_input ) . " characters";
my $raw_octets = decode('UTF-8', $raw_input, Encode::FB_DEFAULT);
my $csv = encode('UTF-8', $raw_octets, Encode::FB_CROAK);
debug "STARTUP CLEAN " . length( $csv ) . " characters";

my ( $header_line, @data_lines ) = split /\n/, $csv;

say $header_line;

debug "STARTUP LINES " . @data_lines;
say process_line( $_ ) foreach @data_lines;

sub process_line {
    my ( $raw_line ) = @_;
    debug "PROCESS IN: [$raW_line]";
    my @fields = quotewords( ',', 0, $raw_line );
    debug "PROCESS FIELDS IN: [" . join '][', @fields . ']';
    # ... process fields ...
    debug "PROCESS FIELDS OUT: [" . join '][', @fields . ']';
    my $result_line = join ',', @fields;
    debug "PROCESS OUT: [$result_line]";
    return $result_line;
}
