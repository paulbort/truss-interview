# Paul Bort's normalize.pl for Truss

## Prerequisites
* Perl 5.14 or later
* The Date::Manip module from CPAN

This should install all of the prerequisites:
```bash
sudo apt-get install perl libdate-manip-perl
```

## To run

As specified, the program expects UTF-8 CSV from STDIN
and produces UTF-8 CSV on STDOUT. For example:

```bash
perl normalize.pl < sample.csv > output.csv
```

## Other Notes

Please submit your solution by emailing a link to [hiring@truss.works](mailto:hiring@truss.works). More details on what we are looking for are included in each problem description linked to below.