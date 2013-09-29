package StoreBlioRecreate;
use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;

use Moose;
extends 'ZeroBlog::Subscriber';
with 'MooseX::Getopt';

use Path::Class;
use DBI;
use DateTime;

my $blio_base = dir('/home/domm/privat/domm.plix.at');
my $DBH = DBI->connect("dbi:SQLite:dbname=".$blio_base->file('sqlite','microblog.db'),'','');

__PACKAGE__->new_with_options->run(sub {
    my ($self, $msg) = @_;
    my ($message) = @$msg;

    say "storing message in DB";
    $DBH->do(
        'INSERT INTO microblog (date,message) values (?,?)',undef,
        DateTime->now(time_zone=>'local')->iso8601,
        $message
    );
    say "rebuilding website";
    system($blio_base->file('build')->stringify);
});

1;
