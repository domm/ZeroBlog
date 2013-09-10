use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use local::lib "$FindBin::Bin/../local";
use 5.014;

use ZeroBlog::Broker;
ZeroBlog::Broker->new->run;

