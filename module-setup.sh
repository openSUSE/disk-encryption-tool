#!/bin/bash

# called by dracut
check() {
	require_any_binary cryptsetup || return 1
	return 0
}

# called by dracut
depends() {
	echo "crypt"
	return 0
}

# called by dracut
install() {
	instmods dmi_sysfs # for systemd credentials via smbios
	inst_multiple -o cryptsetup-reencrypt
	inst_multiple cryptsetup btrfs mktemp getopt mountpoint findmnt sfdisk tac sed hexdump keyctl partx

	inst_script "$moddir"/disk-encryption-tool /usr/bin/disk-encryption-tool
	inst_script "$moddir"/disk-encryption-tool-dracut /usr/bin/disk-encryption-tool-dracut

	for service in "disk-encryption-tool-dracut.service"; do
		inst_simple "${moddir}/$service" "${systemdsystemunitdir}/$service"
		$SYSTEMCTL -q --root "$initdir" enable "$service"
		#$SYSTEMCTL -q --root "$initdir" enable "debug-shell.service"
	done

	: "${ENCRYPTION_CONFIG:=/etc/encrypt_options}"
	[ -e "$ENCRYPTION_CONFIG" ] && inst_simple "$ENCRYPTION_CONFIG" "/etc/encrypt_options"
}
