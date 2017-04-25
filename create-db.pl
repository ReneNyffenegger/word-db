#!/usr/bin/perl
use warnings;
use strict;

use WordDB;

if (-f $WordDB::db_path) {
  print "DB already exists, deleting it\n";
  unlink $WordDB::db_path;
}

WordDB::open();
WordDB::sql("create table word(
  id             integer not null primary key,
  word           text    not null unique,
  first_name_cnt integer not null,
  last_name_cnt  integer not null
)");

WordDB::commit();
