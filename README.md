# Paul Bort's normalize.pl for Truss

## Prerequisites
* Perl 5.14 or later
* The Date::Manip module from CPAN

This should install all of the prerequisites on an Ubuntu or Debian-flavored Linux:
```bash
sudo apt-get -y install perl libdate-manip-perl
```

## To run

As specified, the program expects UTF-8 CSV from STDIN
and produces UTF-8 CSV on STDOUT. For example:

```bash
perl normalizer.pl < sample.csv > output.csv
```

## Other Notes

Tested on Raspbian GNU/Linux 10 (buster).
