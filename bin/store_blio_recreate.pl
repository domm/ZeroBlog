use 5.014;
use Moose;
use ZMQx::Class;
use AnyEvent;
use Path::Class;
use DBI;
use DateTime;

my $blio_base = dir('/home/domm/privat/domm.plix.at');
my $DBH = DBI->connect("dbi:SQLite:dbname=".$blio_base->file('sqlite','microblog.db'),'','');

my $sub = ZMQx::Class->socket( 'SUB', connect => 'tcp://localhost:3334' );
$sub->subscribe('');

my $watcher = $sub->anyevent_watcher( sub {
    while ( my $msg = $sub->receive ) {
        my ($message) = @$msg;
        say scalar(localtime)." got $message";
        $DBH->do(
            'INSERT INTO microblog (date,message) values (?,?)',undef,
            DateTime->now(time_zone=>'local')->iso8601,
            $message
        );
        say "rebuilding website";
        system($blio_base->file('build')->stringify);
    }
});
AnyEvent->condvar->recv;

1;
