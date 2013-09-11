use strict;
use warnings;
use FindBin;

use local::lib "/home/domm/perl/ZeroBlog/local";
use lib "/home/domm/perl/ZeroBlog/lib";

use ZeroBlog::Publisher::IrssiPlugin;

Irssi::command_bind('zb', 'zero_blog');
Irssi::command_bind('zb_config', 'config');
