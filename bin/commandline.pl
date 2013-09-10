use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";
use 5.014;
use ZeroBlog::Publisher;

# TODO getopt
my $endpoint = shift(@ARGV);
my $secret = shift(@ARGV);

my $client = ZeroBlog::Publisher->new(
    endpoint => $endpoint,
    secret => $secret,
);
say $client->send(join(' ',@ARGV));
