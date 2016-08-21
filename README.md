wargames
========

Shell script to simulate the W.O.P.R. computer from WarGames

This is a simple script intended to simulate the interaction with
the W.O.P.R. computer from the film WarGames.
( http://www.mgm.com/#/our-titles/2117/WarGames/ )

If you were deranged enough to want to use inetd to have this directly
connectable via a telnet port you could:

a) Call it directly
- Create a wopr user, compile wopr.c into the same directory as wargames.sh
- Add an entry of the following to inetd.conf
  telnet stream tcp nowait wopr /.../wargames.sh

b) Call it from telnetd
- Create a wopr user, compile wopr.c into the same directory as wargames.sh
- Copy /etc/gettytab 'default' to 'wopr', replace im= with lo=/.../wargames.sh
- Add an entry of the following to inetd.conf
  telnet stream tcp nowait wopr /usr/libexec/telnetd telnetd -g wopr -a off -h

The former has the advantage of a telnetd to correctly intepret all the IAC
sequences, but will require some clients to use 'telnet -K' to connect

