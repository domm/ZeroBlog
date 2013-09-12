package ZeroBlog::Publisher;
use 5.014;
use Moose;
use ZMQx::Class;
use Digest::SHA1 qw(sha1_hex);

use ZMQ::Constants qw(:all);

has 'secret' => (is=>'ro',isa=>'Str',required=>1);
has 'endpoint' => (is=>'ro',isa=>'Str',required=>1);
has 'requestor' => (is=>'ro',isa=>'ZMQx::Class::Socket',lazy_build=>1,required=>1);
sub _build_requestor {
    my $self = shift;
    return ZMQx::Class->socket( 'REQ', connect => $self->endpoint, {
        rcvtimeo=>500,
        linger=>0
    } );
}

sub send {
    my ($self, $message) = @_;

    $message =~ s/\s+$//;
    return 'error','no message' unless $message;
    my $token = sha1_hex($message,$self->secret);

    my $socket = $self->requestor;
    my $rv;
    eval {
        $socket->send([$token, $message]);
        $rv = $socket->receive(1);
    };
    if ($@ || !$rv) {
        return ('error', $@ || 'connection timeout' );
    }
    else {
        return $rv->[0], '';
    }
}

__PACKAGE__->meta->make_immutable;
1;
