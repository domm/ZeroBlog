package ZeroBlog::Broker;
use 5.014;
use Moose;
use ZMQx::Class;
use AnyEvent;
use Digest::SHA1 qw(sha1_hex);

has 'base_port' => (is=>'ro',isa=>'Int',default=>'3333');
has 'secret' => (is=>'ro',isa=>'Str',required=>1);

has 'receiver' => (is=>'ro',isa=>'ZMQx::Class::Socket',lazy_build=>1,required=>1);
sub _build_receiver {
    my $self = shift;
    return ZMQx::Class->socket( 'REP', bind => 'tcp://*:'.$self->base_port );
}
has 'publisher' => (is=>'ro',isa=>'ZMQx::Class::Socket',lazy_build=>1,required=>1);
sub _build_publisher {
    my $self = shift;
    return ZMQx::Class->socket( 'PUB', bind => 'tcp://*:'.($self->base_port+1) );
}

sub run {
    my $self = shift;

    say "Receiver listening on ".$self->receiver->get_last_endpoint;
    say "Publisher sending on ".$self->publisher->get_last_endpoint;

    $self->loop;
}

sub loop {
    my $self = shift;

    my $receiver = $self->receiver;
    my $publisher = $self->publisher;

    my $watcher = $receiver->anyevent_watcher( sub {
        while ( my $msg = $receiver->receive ) {
            my ($token, $message) = @$msg;
            say "got ".join(' - ',@$msg);
            my $check_token = sha1_hex($message,$self->secret);
            if ($check_token eq $token) {
                $receiver->send('ok');
                $publisher->send($message);
            }
            else {
                $receiver->send('bad token, message rejected');
            }
        }
    });
    AnyEvent->condvar->recv;
}

__PACKAGE__->meta->make_immutable;
1;
