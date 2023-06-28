Convert a plain text kiwi image into one with LUKS full disk
encryption. Supports both raw and qcow2 images. It assumes that the
third partition is the root fs using btrfs.
After encrypting the disk, the fs is mounted and a new initrd
created as well as the grub2 config adjusted.

The script can either encrypt the image directly, or alternatively
add code to the initrd of the image. In the latter case the image
would encrypt itself on first boot.

Example to encrypt an image:

    addimageencryption -v SLE-Micro.x86_64-5.4.0-Default-GM.raw

Example to encrypt on first boot:

    addimageencryption -v --prime SLE-Micro.x86_64-5.4.0-Default-GM.raw

Parameters for cryptsetup-reencrypt(8) can be passed via
/etc/encrypt_options. One option per line, e.g.

   --type=luks1
   --iter-time=2000

It's also possible to integrate with combustion. The combustion
script would have to look like this:

    #!/bin/bash
    # combustion: encrypt
    if [ "$1" = "--encrypt" ]; then
        echo 12345 | addimageencryption -v
    else
        echo root:12345 | chpasswd
    fi
