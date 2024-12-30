---
title: makerbase-automount.service files
layout: page
parent: Modifications by Sovol
---
# makerbase-automount.service files
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## /usr/lib/systemd/system/makerbase-automount.service
```
[Service]
Type=forking
GuessMainPID=no
ExecStart=/usr/bin/makerbase-automount %I
```

## /usr/bin/makerbase-automount
```
#!/bin/sh
#$1 = <dev>

# Default options to use for mounting
AUTOMOUNT_OPTS='users'
# Default type to use for mounting
AUTOMOUNT_TYPE='auto'

# Directory to look for type-specific settings
confdir=/etc/makerbase-automount.d

# Directory to use as parent media dir for mountpoints
# mediadir=/media
#mediadir=/home/mks/gcode_files
mediadir=/home/mks/printer_data/gcodes

[ $(id -u) != 0 ] && {
    echo "This tool requires root permissions"
    exit 1
}

log() {
    echo "$*" | systemd-cat -p ${loglevel:-info} -t "media-automount"
}

alias debuglog="loglevel=debug log"
alias errorlog="loglevel=err log"

if ! [ "$1" ]
then
    errorlog "missing arguments! a device name must be provided"
    exit 1
else
    dev=/dev/${1##*/}
fi

# Check if the device exists, if not but mounted, umount it
if ! [ -b $dev ]
then
    if grep /etc/mtab -qe "^$dev"
    then
        log "$dev device removed, umounting and cleaning $mediadir"
        if umount "$dev"
        then
            exitcode=0
        else
            exitcode=$?
            errorlog "Error umounting $dev errcode:$exitcode"
            errorlog "Command was: umount $dev"
        fi
    else
        # prevent it from failing on nonexistent devices and degrading systemctl boot
        exitcode=0
        errorlog "device doesn't exist anymore or is not a block device: $dev"
    fi

    # cleanup
    for dir in "$mediadir"/*
    do
        # Only clean non active mountpoints that have no /etc/fstab entry
        if [ -d "$dir" ] && ! mountpoint -q "$dir" && awk '$2==dir'"{exit 1}' /etc/fstab; then
            rmdir "$dir"
        fi
    done
    exit $exitcode
fi

# Load additional info for the block device
eval $(blkid -po export $dev)

# Devices with unknown type will be ignored
if [ -z "$TYPE" ]
then
    debuglog "$dev has no known filesystem type, ignoring mount request"
    exit 0
fi

# Check /etc/fstab for an entry corresponding to the device
[ "$UUID" ] && fstab=$(grep /etc/fstab -e "^[^#]*${UUID}") || \
[ "$LABEL" ] && fstab=$(grep /etc/fstab -e "^[^#]*${LABEL}") || \
fstab=$(grep /etc/fstab -e "^[ \t]*$dev[ \t]")

# Don't manage devices that are already in fstab
if [ "$fstab" ]
then
    debuglog "$dev already in /etc/fstab, automount won't manage it: ${fstab#\t}"
    exit 0
fi

# directory name
# AUTOMOUNT_DIR="${mediadir}/${LABEL:-${dev##*/}}.$TYPE"
# AUTOMOUNT_DIR="${mediadir}/${LABEL:-${dev##*/}}"
#AUTOMOUNT_DIR="${mediadir}/${1##*/}"
AUTOMOUNT_DIR="${mediadir}/USB"

# Avoid conflicts when multiple devices have the same label
if [ -e "$AUTOMOUNT_DIR" ] && mountpoint -q "$AUTOMOUNT_DIR"
then
    dups=$(find "${AUTOMOUNT_DIR}*" -maxdepth 0 -printf '.' | wc -c)
    AUTOMOUNT_DIR="${AUTOMOUNT_DIR}_$((dups+1))"
fi

# Load Filesystem-specific configuration for mounting
if [ -e "$confdir/$TYPE" ]
then
    debuglog "loading configuration for fs type $TYPE"
    . "$confdir/$TYPE"
elif [ -e "$confdir/auto" ]
then
    . "$confdir/auto"
fi

log "mounting device $dev in $AUTOMOUNT_DIR"
mkdir -p "$AUTOMOUNT_DIR"
#if mount -t "$AUTOMOUNT_TYPE" -o "$AUTOMOUNT_OPTS" "$dev" "$AUTOMOUNT_DIR"
if mount -t "$AUTOMOUNT_TYPE" -o uid=mks -o gid=netdev "$dev" "$AUTOMOUNT_DIR"
then
    # Notify
    username="$(ps au | awk '$11 ~ /^xinit/ { print $1; exit }')"
    [ "$username" ] && DISPLAY=:0 runuser -u "$username" xdg-open "$AUTOMOUNT_DIR"
    log "Device successfully mounted: $AUTOMOUNT_DIR"
    exit 0
else
    errorlog "Mount error: $?"
    errorlog "Command was : mount -t $AUTOMOUNT_TYPE -o $AUTOMOUNT_OPTS $dev $AUTOMOUNT_DIR"

    rmdir "$AUTOMOUNT_DIR"
    exit 1
fi
```

## /usr/lib/udev/rules.d/60-usbmount.rules
```
# KERNEL==sd[a-z]", NAME="%k", SYMLINK+="%k", GROUP="users"

# ACTION==add", KERNEL==sd[a-z][0-9]", SYMLINK+="%k", GROUP="users", NAME="%k"

# ACTION==add", KERNEL==sd[a-z][0-9]", RUN+="/bin/mkdir -p /home/mks/gcode_files/%k"

# ACTION==add", KERNEL==sd[a-z][0-9]", RUN+="/bin/systemd-mount --no-block --collect /dev/%k /home/mks/gcode_files/%k"

# ACTION==remove", KERNEL==sd[a-z][0-9]", RUN+="/bin/systemd-umount /home/mks/gcode_files/%k"

# ACTION==remove", KERNEL==sd[a-z][0-9]", RUN+="/bin/rm -rf /home/mks/gcode_files/%k"

# mount the device when added
KERNEL==sd[a-z]*", ACTION==add",      RUN+="/usr/bin/systemctl --no-block restart makerbase-automount@%k.service"

# clean up after device removal
KERNEL==sd[a-z]*", ACTION==remove",   RUN+="/usr/bin/systemctl --no-block restart makerbase-automount@%k.service"
```

## /usr/lib/udev/rules.d/99-makerbase-automount.rules
```
# none
```

## /etc/makerbase-automount.d/auto
```
# -*- sh -*-

# Options to use for auto-mounting generic filesystems
AUTOMOUNT_OPTS='users'

# Type to use for auto-mounting generic filesystems
AUTOMOUNT_TYPE=auto
```

## /etc/makerbase-automount.d/hfsplus
```
# -*- sh -*-

# Options to use for auto-mounting devices detected with an hfsplus filesystem
AUTOMOUNT_OPTS=ro,users,relatime
```

## /etc/makerbase-automount.d/ntfs
```
# -*- sh -*-

# Mount options to use for auto-mounting NTFS drives
AUTOMOUNT_OPTS='errors=remount-ro,relatime,utf8,users,flush'

# If NTFS-3G is installed, use it as the mount type
hash ntfs-3g && AUTOMOUNT_TYPE="ntfs-3g"
```

## /etc/makerbase-automount.d/vfat
```
# -*- sh -*-

# Options to use for auto-mounting devices detected with a vfat filesystem
AUTOMOUNT_OPTS='errors=remount-ro,relatime,utf8,users,flush,gid=100,dmask=000,fmask=111'
```

----
Back to [start](index.md)
