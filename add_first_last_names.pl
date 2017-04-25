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

open (my $in, '<', '...');


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

  if ($last_last_name ne $last_name and $last_first_name ne $first_name) {
#   print "$first_name\t$last_name\n";

    for my $first_name_ (split ' ', $first_name) {
      $first_name_ =~ s/ *//g;
      WordDB::word_is_firstname($first_name_);
    }
    for my $last_name_ (split '-', $last_name) {
      $last_name_ =~ s/ *//g;
      WordDB::word_is_firstname($last_name_);
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
