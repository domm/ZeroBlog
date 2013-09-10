package ZeroBlog::Publisher;
use 5.014;
use Moose;
use ZMQx::Class;
use Digest::SHA1 qw(sha1_hex);

has 'secret' => (is=>'ro',isa=>'Str',required=>1);
has 'endpoint' => (is=>'ro',isa=>'Str',required=>1);
has 'requestor' => (is=>'ro',isa=>'ZMQx::Class::Socket',lazy_build=>1,required=>1);
sub _build_requestor {
    my $self = shift;
    return ZMQx::Class->socket( 'REQ', connect => $self->endpoint );

}

sub send {
    my ($self, $message) = @_;
    my $socket = $self->requestor;

    $message =~ s/\s+$//;
    my $token = sha1_hex($message,$self->secret);

    $socket->send([$token, $message]);
    my $rv = $socket->receive(1);

    if ($rv && ref($rv) eq 'ARRAY' && $rv->[0] eq 'ok') {
        return 1;
    }
    else {
        die $rv;
    }
}

__PACKAGE__->meta->make_immutable;
1;