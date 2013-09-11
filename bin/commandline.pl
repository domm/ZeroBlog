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
$client->send(join(' ',@{$client->extra_argv}));

1;
