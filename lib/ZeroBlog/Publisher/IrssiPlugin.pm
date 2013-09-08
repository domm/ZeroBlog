package ZeroBlog::Publisher::IrssiPlugin;
use 5.014;
use strict;
use warnings;

use ZMQx::Class;
use Digest::SHA1 qw(sha1_hex);
use Irssi qw(
    window_find_name command_bind
    settings_add_str settings_get_str  settings_set_str
    timeout_add signal_add_first
    signal_add signal_stop
    windows_refnum_last
    signal_add_last
    active_win
);
use Exporter qw(import);
our @EXPORT = qw(config);
our $VERSION = '0.01';
our %IRSSI = (
    authors     => 'Thomas Klausner',
    contact     => 'domm@plix.at',
    name        => 'microblog',
    description => q{We don't need twitter!},
);

my @settings = qw(secret address);
foreach (@settings) {
    settings_add_str('zeroblog','zeroblog_'.$_,'');
}

sub config {
    my ($data, $server, $witem) = @_;
    my ($key, $value) = split(/\s+/,$data,2);

    if ($key && $value) {
        settings_set_str('zeroblog_'.$key, $value);
        active_win()->print("set $key to >".settings_get_str('zeroblog_'.$key)."<");
    }
    elsif ($key) {
        active_win()->print("$key is >".settings_get_str('zeroblog_'.$key)."<");
    }
    else {
        foreach my $thiskey (@settings) {
            active_win()->print("$thiskey is >".settings_get_str('zeroblog_'.$thiskey)."<");
        }
    }
}

1;

