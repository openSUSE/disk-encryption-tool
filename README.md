Convert a plain text kiwi image into one with LUKS full disk
encryption. Supports both raw and qcow2 images. It assumes that the
third partition is the root fs using btrfs.
After encrypting the disk, the fs is mounted and a new initrd
created as well as the grub2 config adjusted.
