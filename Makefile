install:
	cp -f etc/ppp/ip-down etc/ppp/ip-up /etc/ppp/

	cp -f \
		usr/local/bin/vpn-autoconnect \
		usr/local/bin/vpn-autoconnectd \
		usr/local/bin/vpn-config \
		usr/local/bin/vpn-connect \
		usr/local/bin/vpn-disconnect \
		usr/local/bin/vpn-is-connected \
		/usr/local/bin/

	cp -f usr/local/etc/vpn.config /usr/local/etc/vpn.config

	/usr/local/bin/vpn-config

	cp -f Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist /Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist
	launchctl load /Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist

uninstall:
	rm -f /etc/ppp/ip-down /etc/ppp/ip-up

	launchctl unload /Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist
	rm -f /Library/LaunchDaemons/com.ratijas.VPN.keepAlive.plist

	rm -f /usr/local/bin/vpn-config
	rm -f /var/run/vpn-autoconnect-status

	rm -f \
		/usr/local/bin/vpn-autoconnect \
		/usr/local/bin/vpn-autoconnectd \
		/usr/local/bin/vpn-config \
		/usr/local/bin/vpn-connect \
		/usr/local/bin/vpn-disconnect \
		/usr/local/bin/vpn-is-connected