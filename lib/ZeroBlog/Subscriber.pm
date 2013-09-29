package ZeroBlog::Subscriber;
use 5.014;
use Moose;
use ZMQx::Class;
use AnyEvent;

has 'endpoint'  => ( is => 'ro', isa => 'Str', required => 1 );
has 'subscribe' => ( is => 'ro', isa => 'Str', default  => '' );
has 'subscriber' => (
    is         => 'ro',
    isa        => 'ZMQx::Class::Socket',
    lazy_build => 1,
    required   => 1
);

sub _build_subscriber {
    my $self = shift;
    return ZMQx::Class->socket( 'SUB', connect => $self->endpoint );
}

sub run {
    my ( $self, $callback ) = @_;

    my $subscriber = $self->subscriber;
    $subscriber->subscribe( $self->subscribe );
    my $watcher = $subscriber->anyevent_watcher(
        sub {
            while ( my $msg = $subscriber->receive ) {
                &$callback( $self, $msg );
            }
        } );
    AnyEvent->condvar->recv;
}

1;
