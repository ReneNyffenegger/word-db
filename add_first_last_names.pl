#!/usr/bin/perl
use warnings;
use strict;

use utf8;
use Time::HiRes qw(time);

use WordDB;
WordDB::open();

# WordDB::word_is_firstname('René'   );
# WordDB::word_is_firstname('Chantal');
# WordDB::word_is_firstname('Peter');
# WordDB::word_is_firstname('René'   );
# WordDB::word_is_lastname ('Peter');
# WordDB::word_is_lastname ('Nyffenegger');

open (my $in, '<', '...') or die;


my $last_first_name = '?';
my $last_last_name  = '?';
my $cnt = 0;
my $t0 = time;
my $t  = time;
while (my $line = <$in>) {
  my ($first_name, $last_name) = (split '\|', $line)[1,2];

  next if lc($first_name) =~ /test/;
  next if lc($last_name ) =~ /test/;
  next if lc($first_name) =~ /\d/;
  next if lc($last_name ) =~ /\d/;
  next if lc($first_name) =~ /\bcantonal/;
  next if lc($last_name ) =~ /\bcantonal/;
  next if lc($first_name) =~ /\bkanton/;
  next if lc($last_name ) =~ /\bkanton/;
  next if lc($first_name) =~ /\bservice/;
  next if lc($last_name ) =~ /\bservice/;
  next if lc($first_name) =~ /\bristorant/;
  next if lc($last_name ) =~ /\bristorant/;
  next if lc($first_name) =~ /\brestaurant/;
  next if lc($last_name ) =~ /\brestaurant/;
  next if lc($first_name) =~ /\boffice\b/;
  next if lc($last_name ) =~ /\boffice\b/;
  next if lc($first_name) =~ /nanana/;
  next if lc($last_name ) =~ /nanana/;
  next if lc($first_name) =~ /fsdfsd/;
  next if lc($last_name ) =~ /fsdfsd/;
  next if lc($first_name) =~ /#/;
  next if lc($last_name ) =~ /#/;
  next if lc($first_name) =~ /\bdial_/;
  next if lc($last_name ) =~ /\bdial_/;
  next if lc($first_name) =~ /\bgmbh/;
  next if lc($last_name ) =~ /\bgmbh/;
  next if lc($first_name) =~ /\bag\b/;
  next if lc($last_name ) =~ /\bag\b/;
  next if lc($first_name) =~ /\bsa\b/;
  next if lc($last_name ) =~ /\bsa\b/;
  next if lc($first_name) =~ m!c/o!;
  next if lc($last_name ) =~ m!c/o!;

  if ($last_last_name ne $last_name and $last_first_name ne $first_name) {
#   print "$first_name\t$last_name\n";

    for my $first_name_ (split ' ', $first_name) {
      $first_name_ =~ s/^ *//g;
      $first_name_ =~ s/ *$//g;
      $first_name_ =~ s/[().&+\/*]//g;
      $first_name_ =~ s/(.)(.*)/\U$1\L$2/g;
      $first_name_ =~ s/,$//;
      WordDB::word_is_firstname($first_name_) if $first_name_ and length($first_name_) > 1;
    }
    for my $last_name_ (split '-', $last_name) {
      if ($last_name_ !~ /Del? /) {
        $last_name_ =~ s/^ *//g;
        $last_name_ =~ s/ *$//g;
        $last_name_ =~ s/[().&+\/*]//g;
        $last_name_ =~ s/(.)(.*)/\U$1\L$2/g;
        $last_name_ =~ s/ dr$//;
        $last_name_ =~ s/ prof$//;
        $last_name_ =~ s/,$//;
      }
      WordDB::word_is_lastname($last_name_) if $last_name_ and length($last_name_) > 1;
    }

    $last_last_name  = $last_name;
    $last_first_name = $first_name;

    $cnt ++;
    unless ($cnt%1000) {
      my $t1 = time;
      printf ("%6d | %6.3f %6.3f\n", $cnt, ($t1-$t), ($t1-$t0) / ($cnt/1000)) unless $cnt % 1000;
      $t = $t1;
    }
  }
}


WordDB::commit();
