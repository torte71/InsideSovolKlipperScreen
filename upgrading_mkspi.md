---
title: Upgrading from MKS-PI images
layout: page
parent: Custom firmware options
nav_order: 4
has_toc: false
---
# Upgrading from MKS-PI images
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Unsupported images
- Original Sovol/Makerbase image
  - Upgrading from armbian-buster based images is **not** supported.
  - You need to start from a bookworm based image.

## Supported images
- Images based on MKS-PI, e.g.
  - from <https://github.com/redrathnure/armbian-mkspi>
  - complete klipper image ["sovolized-v25.2.0.05"](https://github.com/torte71/mksklipad50-klipper-images/releases/tag/v25.2.0.05)
  - complete klipper image ["sovolized-03-numpy"](https://github.com/torte71/mksklipad50-klipper-images/releases/tag/v24.2.0.03)

- Images based on pre-release MKS-KLIPAD50
  - from <https://github.com/torte71/armbian-mksklipad50/releases>

### Images based on MKS-PI

{: .warning }
> Make an image of your eMMC card before trying to upgrade!

{: .note }
> The next steps need to be done as root. Execute
>
````
sudo su
```
>
> And when you are done, execute `exit` to switch back to the default user (or do a reboot).

- Allow board updates
  - Execute `apt-mark unhold armbian-bsp-cli-mkspi-current armbian-config armbian-firmware armbian-plymouth-theme armbian-zsh base-files linux-dtb-current-rockchip64 linux-headers-current-rockchip64 linux-image-current-rockchip64 linux-u-boot-mkspi-current`

- Update board packages (and others)
  - Execute `apt update && apt -y upgrade`

- Replace BSP (board-support-package) and bootloader package
  - Execute `apt -y remove armbian-bsp-cli-mkspi-current`
  - Execute `apt -y install armbian-bsp-cli-mksklipad50-current linux-u-boot-mksklipad50-current`

- Force updating bootloader
  - Execute `sed -i "/^FORCE_UBOOT_UPDATE/ s/=.*/=yes/" /etc/armbian-release`
  - Execute `dpkg-reconfigure linux-u-boot-mksklipad50-current`
  - Execute `sed -i "/^FORCE_UBOOT_UPDATE/ s/=.*/=/" /etc/armbian-release`

- Load rk805 module at boot (makes status-LEDs work)
  - Execute `echo "pinctrl-rk805" >> /etc/modules`

- Clean up old DTB workaround
  - This will throw some error messages. Simply ignore them.
  - Execute `apt -y remove klipad50-dtb-fix`

- Reboot
  - Execute `reboot`

### Images based on pre-release MKS-KLIPAD50

{: .warning }
> Make an image of your eMMC card before trying to upgrade!

{: .note }
> The next steps need to be done as root. Execute
>
````
sudo su
```
>
> And when you are done, execute `exit` to switch back to the default user (or do a reboot).

{: .important }
> This only applies to images downloaded from
>
> https://github.com/torte71/armbian-mksklipad50/releases
>
> (Klipad50 images downloaded from armbian.com do not need any changes.)

- Allow board updates
  - Execute `apt-mark unhold armbian-bsp-cli-mkspi-current armbian-config armbian-firmware armbian-plymouth-theme armbian-zsh base-files linux-dtb-current-rockchip64 linux-headers-current-rockchip64 linux-image-current-rockchip64 linux-u-boot-mkspi-current`

- Update board packages (and others)
  - Execute `apt update && apt -y upgrade`

- Force updating bootloader
  - Execute `sed -i "/^FORCE_UBOOT_UPDATE/ s/=.*/=yes/" /etc/armbian-release`
  - Execute `dpkg-reconfigure linux-u-boot-mksklipad50-current`
  - Execute `sed -i "/^FORCE_UBOOT_UPDATE/ s/=.*/=/" /etc/armbian-release`

- Reboot
  - Execute `reboot`


