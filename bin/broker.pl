package RunBroker;
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use local::lib "$FindBin::Bin/../local";
use 5.014;

use Moose;
extends 'ZeroBlog::Broker';
with 'MooseX::Getopt';

__PACKAGE__->new_with_options->run;
1;
