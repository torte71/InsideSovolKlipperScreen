---
title: Update problems
layout: page
parent: Original firmware (by Sovol)
---
# Update problems
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

<!-- See also: <https://github.com/3DPrintDemon/How-to-Update-Sovol-Klipper-Screen-To-Latest-Klipper-SV06-and-SV07 -->

## System / Kernel (black screen)

- **Updating "System" breaks KlipperScreen**  
  - **Cause**: Stock armbian kernels are incompatible with KlipperScreen
    - kernel on KlipperScreen is linux-5.16.20-rockchip64 (Version: 22.05.0-trunk)
      - This kernel is not found on the armbian servers (latest version: 5.16.11-rockchip64)
    - All standard kernels are incompatible:
      - Screen stays black
      - WiFi is not working
      - "/dev/spidev*" is not created (ADXL543 acceleration sensor requires spidev)
  - **Fix:**
    - **Revert to old kernel**  
      See [Factory reset using Sovol’s armbian-update.deb](bootloop.html#factory-reset-using-sovols-armbian-updatedeb)
      - Option a) Factory reset (kills all prior settings)
         - Download the armbian-update.deb and flash it using an USB-stick (as shown in the previous link).
      - Option b) Revert just kernel (keeps settings)
         - Upload armbian-update.deb to your KlipperScreen.  
           E.g. using the web-frontend: Navigate to "Machine" and use the "upload file" button (or use scp or whatever for uploading).
         - Use ssh/putty to log into your KlipperScreen.
         - Change into the directory where you uploaded armbian-update.deb to.  
           For the mainsail example: `cd ~/printer_data/config`
         - Extract kernel package:  
	   `dpkg -x armbian-update.deb xtract`
         - Install (downgrade) kernel:  
	   `sudo dpkg -i xtract/root/system_deb/linux-image-edge-rockchip64_22.05.0-trunk_arm64.deb`
         - Install (downgrade) the dtb file:  
	   `sudo cp xtract/home/mks/rk3328-roc-cc.dtb /boot/dtb/rockchip/`
    - **Keep that kernel-version** (choose one of the following options):
      - Option a) Don't update "System" at all.
      - Option b) Keep just that kernel-version (allows updating "System"):  
           `sudo apt-mark hold linux-image-edge-rockchip64 linux-dtb-edge-rockchip64`
      - Option c) Freeze the kernel using "armbian-config".


## Armbian Buster: End Of Life
Sovol's KlipperScreen still uses the outdated Armbian "buster" version, they've not released a newer firmware version to the current day (Oct. 2024).
The repositories for this version have been taken offline in spring 2024.
  * Updating the system packages using apt (e.g. `apt-get update` or `apt-get upgrade`) does not work any longer, because these updates do not exist any more.
  * The missing system updates make it more and more difficult updating the Klipper components. E.g. recent "KlipperScreen" service versions depend on Python-3.8, but the device is stuck at Python-3.7.
  * At least one can not accidentally brick the device by updating the kernel or .dtb files any longer, as these files simply do not exist any longer.
  * It is possible to flash a recent Armbian version, but it takes more than just a few mouseclicks.  
     See these guides:
    * [Rebuilding](rebuilding.html) from scratch using Armbian for MKS-Klipad50
    * Vasyl's guide (older version based on MKS-PI images): <https://github.com/vasyl83/SV07update>
  * You can also use a readily prepared image (built as on my guide)
    * [Image](image.html)


## KlipperScreen / Python 3.8
The last version of KlipperScreen that works with python 3.7 is v0.4.1.
I guess the easiest fix is resetting KlipperScreen to that revision and never updating it afterwards. That means:
  * Log into the KlipperScreen using SSH or Putty and enter the following commands:
  * `cd ~/KlipperScreen`
  * `git reset --hard v0.4.1`
(I haven't tested this, but it is taken from the KlipperScreen FAQ at <https://klipperscreen.readthedocs.io/en/latest/FAQ/>)

Other options are:
  * Revert the whole system to its original state by flashing the emmc card with Sovol's image (and not updating afterwards): <https://drive.google.com/file/d/1A1-Rw1vDPUT4pnvMOBWTd098l2aShehC/view>
  * Flash a recent armbian image to the emmc card (then you can update afterwards).
  * Maybe its possible to manually download, compile and install python 3.8, but I'd expect many issues with that (possibly missing dependencies, too little free space on the emmc). <https://devguide.python.org/getting-started/setup-building/>


## Moonraker Timelapse
The moonraker timelapse script has a dependency check at the starts, which prevents the installation on the outdated Armbian buster version.
By removing that check, it should be possible to install the timelapse script.
See Gergo's [Youtube guide](https://www.youtube.com/watch?v=86CFV_CbrvQ&t=457s)


