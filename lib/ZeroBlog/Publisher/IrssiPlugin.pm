package ZeroBlog::Publisher::IrssiPlugin;
use 5.014;
use strict;
use warnings;
use ZeroBlog::Publisher;

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
our @EXPORT = qw(config zero_blog);
our $VERSION = '0.01';
our %IRSSI = (
    authors     => 'Thomas Klausner',
    contact     => 'domm@plix.at',
    name        => 'microblog',
    description => q{We don't need twitter!},
);

my @settings = qw(secret endpoint);
foreach (@settings) {
#    unless (settings_get_str('zeroblog_'.$_)) {
        Irssi::settings_add_str('zeroblog','zeroblog_'.$_,'');
#    }
}

my $PUBLISHER;
sub get_publisher {
    return $PUBLISHER if $PUBLISHER;
    my $endpoint = settings_get_str('zeroblog_endpoint');
    unless ($endpoint) {
        active_win->print("Please set Broker endpoint via /zb_config endpoint ENDPOINT");
        return;
    }
    my $secret = settings_get_str('zeroblog_secret');
    unless ($secret) {
        active_win->print("Please set secret via /zb_config secret SECRET");
        return;
    }

    $PUBLISHER = ZeroBlog::Publisher->new(
        endpoint=>$endpoint,
        secret=>$secret,
    );
    return $PUBLISHER;
}

sub config {
    my ($data, $server, $witem) = @_;
    my ($key, $value) = split(/\s+/,$data,2);

    if ($key && $value) {
        settings_set_str('zeroblog_'.$key, $value);
        active_win->print("set $key to >".settings_get_str('zeroblog_'.$key)."<");
        undef $PUBLISHER;
    }
    elsif ($key) {
        active_win->print("$key is >".settings_get_str('zeroblog_'.$key)."<");
    }
    else {
        foreach my $thiskey (@settings) {
            active_win->print("$thiskey is >".settings_get_str('zeroblog_'.$thiskey)."<");
        }
    }
}


sub zero_blog {
    my ($data, $server, $witem) = @_;

    my $publisher = get_publisher();
    return unless $publisher;
    my $command = 'SAY';
    my $message = $data;
    if ($data =~m{^/me }) {
        $command = 'ME';
        $message =~s{^/me}{domm};
        $data =~s{^/me }{};
    }

    my ($status, $error) = $publisher->send($message);
    if ($status eq 'ok') {
        if ($witem) {
            $witem->command("/$command $data");
        } else {
            active_win->print($data);
        }
    }
    else {
        active_win->print("could not zeroblog: $status $error");
    }
}

1;

