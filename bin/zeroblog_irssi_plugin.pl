use strict;
use warnings;
use FindBin;
use local::lib "$FindBin::Bin/../local";
use lib "$FindBin::Bin/../lib";

use ZeroBlog::Publisher::IrssiPlugin;

Irssi::command_bind('zb', 'zero_blog');
Irssi::command_bind('zb_config', 'config');
