Convert a plain text kiwi image into one with LUKS full disk
encryption. Supports both raw and qcow2 images. It assumes that the
third partition is the root fs using btrfs.
After encrypting the disk, the fs is mounted and a new initrd
created as well as the grub2 config adjusted.

The script can either encrypt the image directly, or alternatively
add code to the initrd of the image. In the latter case the image
would encrypt itself on first boot.
