# automatically reconnect to VPN when commention drops, for Mac OS X.


# install
open terminal, navigate to this directory

    cd path/to/vpn-autoconnect
    sudo make install

sometimes reboot required.


# uninstall

    sudo make uninstall

no reboot needed.


# set up

    vpn-config


# everything bellow this line is more like thoughts about design than instruction.
==================================================================================

to autoconnect or not is determined by content of file `/var/run/vpn-autoconnect-status`.

which VPN to connect is determined by content of file `/usr/local/etc/vpn.config`,
just VPN and configuration names.

## (1)
any command that supposed to enable autoconnect must therefore

1. write "true" to /var/run/vpn-autoconnect-status ;
2. ensure file above is chmod 644;
2. optionally run `vpn-connect` not to wait for automatic trigger.

## (2)
any command that supposed to disable autoconnect must

1. write "false" to /var/run/vpn-autoconnect-status ;
2. NOT run `vpn-disconnect` command;  let it be connected until it fails by itself or explicitly turned off by user.

## (3)
checking for connection status should only check the actual status of  "System Events".

## (4)
any command that supposed to disconnect VPN must also run (2) first.


## executable scripts

by default installed to `/usr/local/bin/`


    vpn-autoconnectd

MUST NOT be called directly!

deamon that run in a loop and connect to VPN according to the content of file `/var/run/vpn-autoconnect-status`.
should be started by launchd w/o arguments.
if it fails for some reason, it should be restarted in 5-10 seconds.


    vpn-connect

once connect to VPN and exit.  vpn-autoconnectd may share code base with it or call this directly.
anyway, see description of `/usr/local/etc/vpn.config` file below.


    vpn-disconnect

disconnect from VPN service and deny autoconnecting again


    vpn-is-connected

report VPN status.  return non-zero if not connected.


    vpn-autoconnect [ on | off | st[atus] ]

* w/o arguments is equal to `vpn-autoconnect on`
* with `on` parameter behaves like (1) on top of this file.
* with `off` parameter behaves like (2) on top of this file.
* with `st` or `status` behaves like (3) on top of this file.

    vpn-config

simple shortcut to launch $EDITOR `/usr/local/etc/vpn.config`.


## files:

    /usr/local/etc/vpn.config

here will be configuration file.
file must contain just two lines:
```
VPN service name
service configuration name
```
writen exactly like in System Preferences.  everything else ignored.
it is an error if file does not exist or service name is empty.  however,
if second line is empty, `vpn-connect` would try to connect to the service's
current configuration.


    /Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist

launchd deamon configuration.
tells launchd to run and keep it alive `vpn-autoconnectd` when network connected.


    /var/run/vpn-autoconnect-status

status file.  can contain single line "`true`" or "`false`".  this is how
`vpn-autoconnectd` determines whether to autoconnect.
**owner by root!**
should be modified only by (1) and (2) on the top of this file.


## hooks:

    /etc/ppp/ip-up interface-name tty-device speed local-IP-address remote-IP-address ipparam

conforms to (1) on the top of this file.


    /etc/ppp/ip-down interface-name tty-device speed local-IP-address remote-IP-address ipparam

conforms to (2) on the top of this file.
checks last few lines for `/var/log/ppp.log` to determine if the VPN was intentionally disconnected or dropped.
