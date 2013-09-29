package Echo;
use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;

use Moose;
extends 'ZeroBlog::Subscriber';
with 'MooseX::Getopt';

my $echo = __PACKAGE__->new_with_options;
$echo->run(
    sub {
        my ( $self, $msg ) = @_;
        say "domm microblogged something: " . $msg->[0];
    } );

1;
