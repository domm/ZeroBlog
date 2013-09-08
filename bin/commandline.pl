use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;
use ZMQx::Class;

my $client = ZMQx::Class->socket( 'REQ', connect => 'tcp://localhost:3333' );
$client->send(['abc',$ARGV[0]]);
my $rv = $client->receive(1);
say join(',',@$rv);



