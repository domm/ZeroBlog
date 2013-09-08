use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;
use ZMQx::Class;
use AnyEvent;

my $broker = ZMQx::Class->socket( 'REP', bind => 'tcp://*:3333' );
my $watcher = $broker->anyevent_watcher( sub {
    while ( my $msg = $broker->receive ) {
        say "got ".join(' - ',@$msg);
        $broker->send('ok');
    }
});
AnyEvent->condvar->recv;



