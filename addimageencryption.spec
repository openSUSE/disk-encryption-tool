#
# spec file for package aaa_base
#
# Copyright (c) 2022 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#
# icecream 0

%if 0%{?_build_in_place}
%define git_version %(git log '-n1' '--date=format:%Y%m%d' '--no-show-signature' "--pretty=format:+git%cd.%h")
BuildRequires:  git-core
%else
# this is required for obs' source validator. It's
# 20-files-present-and-referenced ignores all conditionals. So the
# definition of git_version actually happens always.
%define git_version %{nil}
%endif

Name:           addimageencryption
Version:        84.87%{git_version}
Release:        0
Summary:        Tool to reencrypt kiwi raw images
License:        MIT
URL:            https://github.com/lnussel/addimageencryption
Source:         aaa_base-%{version}.tar
Requires:       cryptsetup

%description
Convert a plain text kiwi image into one with LUKS full disk
encryption. Supports both raw and qcow2 images. It assumes that the
third partition is the root fs using btrfs.
After encrypting the disk, the fs is mounted and a new initrd
created as well as the grub2 config adjusted.

%prep
%setup -q

%build

%install
for i in addimageencryption do-addimageencryption.sh module-setup.sh; do
  install -m 755 -D %_sourcedir/$i %buildroot/usr/lib/dracut/modules.d/95addimageencryption/$i
done
mkdir -p %buildroot/usr/bin
ln -s ../lib/dracut/modules.d/95addimageencryption/addimageencryption %buildroot/usr/bin

%files
%license LICENSE
/usr/bin/addimageencryption
/usr/lib/dracut/modules.d/95addimageencryption

%changelog
