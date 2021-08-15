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
use Date::Manip qw( ParseDate UnixDate Date_ConvTZ );

sub debug {
    my ( @msgs ) = @_;
    print STDERR "$_\n" foreach @msgs;
    return;
}

my $raw_input = join "\n", <>;
# debug "STARTUP READ " . length( $raw_input ) . " characters";
my $raw_octets = decode('UTF-8', $raw_input, Encode::FB_DEFAULT);
# $raw_octets is now a bytestream of the input, with replacement character
my $csv = encode('UTF-8', $raw_octets, Encode::FB_CROAK); 
# $csv is now a real, clean UTF-8 string
# debug "STARTUP CLEAN " . length( $csv ) . " characters";

my ( $header_line, @data_lines ) = split /\n+/, $csv;

say $header_line;

# debug "STARTUP LINES " . @data_lines;
say process_line( $_ ) foreach @data_lines;


sub process_line {
    my ( $raw_line ) = @_;
    # debug "PROCESS IN: [$raw_line]";
    my @fields = quotewords( ',', 0, $raw_line );

    # 0: Timestamp: Convert to RFC3339, adjust PT to ET
    my $pt_date = ParseDate( $fields[0] );
    return if not $pt_date;
    my $et_date = Date_ConvTZ( $pt_date, 'America/Los_Angeles', 'America/New_York' );
    return if not $et_date;
    $fields[0] = UnixDate( $et_date, '%O%z' );

    # 1: Address: No change
    $fields[1] = $fields[1];
    # Completely unnecessary assignment, but shows
    #   explicity that the lack of processing
    #   is intentional

    # 2: ZIP: Zero pad left
    return unless $fields[2] =~ /^\d{1,5}$/;
    $fields[2] = substr( '0000' . $fields[2], -5, 5 );
    # Negative offset for substr() starts from the end
    #   of the string and goes backwards

    # 3: FullName: uppercase w/non-latin support
    $fields[3] = uc( $fields[3] );
    #    (Since Perl knows this string is UTF-8,
    #     it knows how to upper-case it correctly)

    # 4: FooDuration: Convert to seconds
    $fields[4] = hms_to_seconds( $fields[4] );
    return if not defined $fields[4];

    # 5: BarDuration: Convert to seconds
    $fields[5] = hms_to_seconds( $fields[5] );
    return if not defined $fields[5];

    # 6: TotalDuration: Sum FooDuration and BarDuration
    #     (Presumed in the same format)
    $fields[6] = $fields[4] + $fields[5];
    # Perl automatically handles scalars changing
    #   from strings to numbrs (int or float)

    # 7: Notes: No change
    $fields[7] = $fields[7];
    # Completely unnecessary assignment, but shows
    #   explicity that the lack of processing
    #   is intentional

    my $result_line = join ',', @fields;
    #debug "PROCESS OUT: [$result_line]";
    return $result_line;
}

sub hms_to_seconds {
    my ( $hms ) = @_;
    #         (hours ):(minutes   ):(seconds      .frac)
    my ( $hours, $minutes, $seconds ) = $hms =~ /^(\d{1,}):([0-5][0-9]):([0-5][0-9](?:\.\d+)?)$/
        or return;

    return ( $hours * 60 * 60 ) + ( $minutes * 60 ) + $seconds;
}
