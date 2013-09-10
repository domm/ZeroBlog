package ZeroBlog::Publisher::IrssiPlugin;
use 5.014;
use strict;
use warnings;

use ZMQx::Class;
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

my @settings = qw(secret address);
foreach (@settings) {
    settings_add_str('zeroblog','zeroblog_'.$_,'');
}
#settings_add_str('zeroblog','zeroblog_secret','abc');
#settings_add_str('zeroblog','zeroblog_address','tcp://localhost:3333');

sub config {
    my ($data, $server, $witem) = @_;
    my ($key, $value) = split(/\s+/,$data,2);

    if ($key && $value) {
        settings_set_str('zeroblog_'.$key, $value);
        active_win->print("set $key to >".settings_get_str('zeroblog_'.$key)."<");
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

my $SOCKET;
sub get_socket {
    return $SOCKET if $SOCKET;
    my $address = settings_get_str('zeroblog_address');
    unless ($address) {
        active_win->print("Please set Broker address via /zb_config address ADDRESS");
        return;
    }
    $SOCKET = ZMQx::Class->socket('REQ', connect => $address);
    return $SOCKET;
}

sub zero_blog {
    my ($data, $server, $witem) = @_;

    my $secret = settings_get_str('zeroblog_secret');
    unless ($secret) {
        active_win->print("Please set secret via /zb_config secret SECRET");
        return;
    }
    my $socket = get_socket();
    return unless $socket;
    my $command = 'SAY';
    my $message = $data;
    if ($data =~m{^/me }) {
        $command = 'ME';
        $message =~s{^/me}{domm};
        $data =~s{^/me }{};
    }
    $message =~ s/\s+$//;
    my $token = sha1_hex($message,$secret);

    $socket->send([$token, $message]);
    my $rv = $socket->receive(1);

    if ($witem) {
        $witem->command("/$command $data");
    } else {
        active_win->print($data);
    }
    active_win->print(join(' ',@$rv));
}

1;

