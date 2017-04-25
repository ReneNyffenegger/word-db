package WordDB;
use DBI;

use 5.10.0;

my $db_dir = "$ENV{digitales_backup}Development/Daten/Word-DB/";
die unless -d $db_dir;
our $db_path = "${db_dir}word.db";

my $dbh;

sub open {

  $dbh = DBI->connect("dbi:SQLite:dbname=$db_path") or die "Could not open/create $db_path";
  sql('PRAGMA synchronous=OFF');
  sql('PRAGMA cache_size=4000000');
  sql('PRAGMA journal_mode=memory');
  $dbh->{AutoCommit} = 0;


}

sub sql {
  my $sql_text = shift;
  $dbh -> do ($sql_text) or die "could not execute $sql_text";
}

sub word_is_firstname {
  my $word       = shift;

  state $sth_select = $dbh -> prepare('select id from word where word = :word');

  $sth_select -> execute($word);
  if (my $r = $sth_select->fetchrow_hashref) {
    state $sth_update = $dbh->prepare('update word set first_name_cnt = first_name_cnt+1 where id = :id') or die;
    $sth_update->execute($r->{id});

  }
  else {
    state $sth_insert = $dbh->prepare('insert into word (word, first_name_cnt, last_name_cnt) values (:word, 1, 0)') or die;
    $sth_insert -> execute($word);
  }
}

sub word_is_lastname {
  my $word       = shift;

  state $sth_select = $dbh -> prepare('select id from word where word = :word');

  $sth_select -> execute($word);
  if (my $r = $sth_select->fetchrow_hashref) {
    state $sth_update = $dbh->prepare('update word set last_name_cnt = last_name_cnt+1 where id = :id') or die;
    $sth_update->execute($r->{id});

  }
  else {
    state $sth_insert = $dbh->prepare('insert into word (word, first_name_cnt, last_name_cnt) values (:word, 0, 1)') or die;
    $sth_insert -> execute($word);
  }
}

sub commit {

  $dbh->commit();

}

1;
