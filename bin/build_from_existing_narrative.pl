#! /usr/bin/env perl

use strict;
use warnings;

while(<>){
  chomp;
  if(/(^# \[.+)/){
    my $modified_header="$_";
    $modified_header =~ s/seasonal\/2022-10-03/seasonal\/jendraft2022-10-27/g; # Change build name
    $modified_header =~ s/,202237/,202237,202239,202241,202242/g; # Add new epiweeks
    print "$modified_header\n"; # Print new header
    print "\nEdit here.\n\n";
    print "$_\n\n"; # Print old header
  }else{
    print "$_\n"; # Print old data
  }
}
