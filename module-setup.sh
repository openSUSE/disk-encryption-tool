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
	inst_multiple -o cryptsetup-reencrypt
	inst_multiple cryptsetup btrfs mktemp getopt mountpoint findmnt sfdisk tac sed hexdump keyctl

	inst_script "$moddir"/addimageencryption /usr/bin/addimageencryption
	inst_script "$moddir"/addimageencryption-initrd /usr/bin/addimageencryption-initrd
	inst_script "$moddir"/generate-recovery-key /usr/bin/generate-recovery-key

	for service in "addimageencryption-initrd.service"; do
		inst_simple "${moddir}/$service" "${systemdsystemunitdir}/$service"
		$SYSTEMCTL -q --root "$initdir" enable "$service"
		#$SYSTEMCTL -q --root "$initdir" enable "debug-shell.service"
	done

	: "${ENCRYPTION_CONFIG:=/etc/encrypt_options}"
	[ -e "$ENCRYPTION_CONFIG" ] && inst_simple "$ENCRYPTION_CONFIG" "/etc/encrypt_options"
}
