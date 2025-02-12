---
title: Klipad50 DTB fix
layout: page
nav_order: 2
parent: Rebuilding on Armbian-mainline v25.2 (MKS-PI)
---
# Klipad50 DTB fix
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

As the special [DTB file](rk3328-roc-cc_dts.html) for the Klipad50 is not part of the current Armbian images,
it will be overwritten if you install an updated dtb-package.  
To work around that, I've added a dpkg hook, which reinstalls the special DTB whenever
a dtb-packge installation/removal is detected.  
(Idea based on <https://askubuntu.com/questions/63717/execute-command-after-dpkg-installation>)

You can download and install the [Klipad50-dtb-fix](files/klipad50-dtb-fix.deb) with following commands:
```
wget https://torte71.github.io/InsideSovolKlipperScreen/files/klipad50-dtb-fix.deb
sudo dpkg -i klipad50-dtb-fix.deb
```

## /etc/apt/apt.conf.d/90dpkg_post_invoke_klipad50
```
DPkg::Post-Invoke { "/usr/local/bin/klipad50-dtb-fix/dpkg_post_invoke_klipad50.sh"; }
```

## /usr/local/bin/klipad50-dtb-fix/dpkg_post_invoke_klipad50.sh
```
#!/bin/bash
APTPID=$( ps -ho ppid "${PPID}" )
APTCMD=$( ps -ho args ${APTPID} )
DTBDIR=/boot/dtb/rockchip
DTBFILE=$DTBDIR/rk3328-mkspi.dtb
DTBKLIPAD=/usr/local/bin/klipad50-dtb-fix/rk3328-mkspi-klipad50.dtb

if echo $APTCMD|grep -q " \(install\|purge\|autopurge\|remove\|autoremove\) .* linux-dtb-" ; then
        echo Replacing DTB file
        [ -e $DTBFILE ] && mv $DTBFILE $DTBFILE.$(date +"%y%m%d_%H%M%S")
        cp $DTBKLIPAD $DTBFILE
fi
```
