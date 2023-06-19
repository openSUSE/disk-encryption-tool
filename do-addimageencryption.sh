#!/bin/bash
/usr/bin/addimageencryption --mounted /sysroot -v < /dev/console &>/dev/console || die "Encryption failed"
