ZeroBlog
========

Microblog via IRC and ZeroMQ

Installation
============

ZeroBlog comes with a cpanfile listing the deps. Here's one simple way to get it running, assuming you have a modern Perl including cpanm:

git clone git@github.com:domm/ZeroBlog.git
cd ZeroBlog
cpanm -L local --installdeps -n .  # install deps into local, don't run test

Running
=======

Run the broker in one terminal
perl -Ilib -Mlocal::lib=local bin/broker.pl --secret hase
Receiver listening on tcp://0.0.0.0:3333
Publisher sending on tcp://0.0.0.0:3334


Start the echo-client in another term
perl -Ilib -Mlocal::lib=local bin/echo.pl --endpoint tcp://0.0.0.0:3334

And now microblog something in yet another term
perl -Ilib -Mlocal::lib=local bin/commandline.pl --secret hase --endpoint tcp://0.0.0.0:3333 Just another message



