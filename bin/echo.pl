use 5.014;
use Moose;
use ZMQx::Class;
use AnyEvent;

my $pub = ZMQx::Class->socket( 'SUB', connect => 'tcp://localhost:3334' );
$pub->subscribe('');

    my $watcher = $pub->anyevent_watcher( sub {
        while ( my $msg = $pub->receive ) {
            say "got ".join(' - ',@$msg);
        }
    });
    AnyEvent->condvar->recv;

1;
