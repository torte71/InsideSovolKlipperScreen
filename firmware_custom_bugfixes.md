---
title: Custom firmware bugfixes
layout: page
parent: Custom firmware options
nav_order: 5
has_toc: false
---
# Custom firmware bugfixes
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Bootloop on MKS-Klipad50 community based images

### Affected image versions

Images prior to the standard support image v25.2.3 are affected, if they had kernel updates enabled.

### Step 1: Stop bootloop (replace uInitrd)

To stop the image from entering the bootloop, the file "uInitrd" needs to be replaced with an older version (e.g. from [25.5.0-trunk.87](https://github.com/armbian/community/releases/download/25.5.0-trunk.87/Armbian_community_25.5.0-trunk.87_Mksklipad50_bookworm_current_6.12.15_minimal.img.xz)).

You can download a working uInitrd file [here](files/uInitrd).

Insert the eMMC card in the eMMC-reader and plug it into the PC. The boot partition should be mounted automatically. Use the explorer (or whatever filemanager) and open the directory of the card.

Replace the file "uInitrd" on the eMMC card with the version you have just downloaded (or taken from a different image).

With this fix, the card should boot correctly, but unless the bootloader got updated, any rebuild of the initrd will start the bootloop again.

### Step 2: Update bootloader

{: .note }
> The next steps need to be done as root. Execute
>
```
sudo su
```
>
> And when you are done, execute `exit` to switch back to the default user.


The bootloader ("u-boot") on the boot partition has to be updated from v2022.07 to v2025.01.

To do this, the u-boot binary package first has to be updated:
```
apt update && apt -y upgrade
```

Then the boot partition has to be updated:
```
echo "FORCE_UBOOT_UPDATE=yes">>/etc/armbian-release ; dpkg-reconfigure linux-u-boot-mksklipad50-current ; sed -i '$ d' /etc/armbian-release
```

Now it should be safe to update all components again.
