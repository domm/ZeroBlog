package RunCommandline;
use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;

use Moose;
extends 'ZeroBlog::Publisher';
with 'MooseX::Getopt';

my $client = __PACKAGE__->new_with_options;
my ($status, $error) = $client->send(join(' ',@{$client->extra_argv}));
say "$status $error";

1;
