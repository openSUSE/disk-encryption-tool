Tool to turn a plain text image into one using LUKS full disk
encryption. There are three modes:

* Directly encrypt a disk image on a host system. The image can then
  be deployed somewhere else
* Prime a disk image by adding code to the initrd of the image that
  encrypts the image on first boot
* Include the initrd code already when building an image. The image
  would then encrypt itself on first boot.

In general the tool is developed with [kiwi](https://github.com/OSInside/kiwi)
in mind. It assumes that the image contains a single root fs using btrfs in the
third partition. Both grub2 and systemd-boot are supported. The tool generates
a

Example to directly encrypt an image:

    disk-encryption-tool -v SLE-Micro.x86_64-5.4.0-Default-GM.raw

Example to prime a plain text image to encrypt on first boot:

    disk-encryption-tool -v --prime SLE-Micro.x86_64-5.4.0-Default-GM.raw


When run on first boot the tool integrates with
[jeos-firstboot](https://github.com/openSUSE/jeos-firstboot/). The encryption
in initrd deploys an automatically generated recovery key, compatible with
[systemd-cryptenroll](https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html).
Later in the real root a jeos-firsboot module then offers to deploy
either the root password or another custom passphrase as well.

Parameters for cryptsetup-reencrypt(8) can be passed via
`/etc/encrypt_options`. One option per line, e.g.

   --type=luks1
   --iter-time=2000

It's also possible to integrate with combustion. The combustion
script would have to look like this:

    #!/bin/bash
    # combustion: encrypt
    if [ "$1" = "--encrypt" ]; then
        echo 12345 | disk-encryption-tool -v --gen-key
    else
        echo root:12345 | chpasswd
    fi
