#!/bin/bash

if [ -z "$1" ]; then
       echo -e "usage: `basename $0` DISTRO
where DISTRO is the Ubuntu version codename (e.g. 14.04 is trusty)\n
The way to use this script is to do the changes to the repo first, i.e. delete or copy in the .deb file to /srv/packages/local-DISTRO, and then run this script\n
This script can be run as an unprivileged user - root is not needed so long as your user can write to the local repository directory"
else
    cd /srv/packages

    # Generate the Packages file
    dpkg-scanpackages -m "$1" > "$1"/Packages
    gzip --keep --force -9 "$1"/Packages

    cd /srv/packages/"$1"

    # Generate the Release file
    cat release-meta > Release
    # The Date: field has the same format as the Debian package changelog entries,
    # that is, RFC 2822 with time zone +0000
    echo -e "Date: `LANG=C date -Ru`" >> Release
    # Release must contain MD5 sums of all repository files (in a simple repo just the Packages and Packages.gz files)
    echo -e 'MD5Sum:' >> Release
    printf ' '$(md5sum Packages.gz | cut --delimiter=' ' --fields=1)' %16d Packages.gz' $(wc --bytes Packages.gz | cut --delimiter=' ' --fields=1) >> Release
    printf '\n '$(md5sum Packages | cut --delimiter=' ' --fields=1)' %16d Packages' $(wc --bytes Packages | cut --delimiter=' ' --fields=1) >> Release
    # Release must contain SHA256 sums of all repository files (in a simple repo just the Packages and Packages.gz files)
    echo -e '\nSHA256:' >> Release
    printf ' '$(sha256sum Packages.gz | cut --delimiter=' ' --fields=1)' %16d Packages.gz' $(wc --bytes Packages.gz | cut --delimiter=' ' --fields=1) >> Release
    printf '\n '$(sha256sum Packages | cut --delimiter=' ' --fields=1)' %16d Packages' $(wc --bytes Packages | cut --delimiter=' ' --fields=1) >> Release

    # Clearsign the Release file (that is, sign it without encrypting it)
    rm InRelease
    gpg --clearsign --digest-algo SHA512 --local-user $USER -o InRelease Release
    # Release.gpg only need for older apt versions
    # gpg -abs --digest-algo SHA512 --local-user $USER -o Release.gpg Release
fi
