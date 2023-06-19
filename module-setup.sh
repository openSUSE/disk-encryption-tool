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
	inst_multiple cryptsetup btrfs mktemp getopt mountpoint findmnt sfdisk tac sed

	inst_script "$moddir"/addimageencryption /usr/bin/addimageencryption

	inst_hook pre-pivot 10 "$moddir/do-addimageencryption.sh"
}
