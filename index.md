---
title: Home
layout: home
nav_order: 1
---

{: .note }
> This is a private project, no guarantees or liabilities apply.  
> The author and this site are not affiliated to Sovol in any kind.  
> The information provided here has been gathered from the web and by analyzing Sovol's KlipperScreen.

# Sovol KlipperScreen (Makerbase MKS KLIPAD50)

## Hardware
  * [Hardware](hardware.html) description of the MKS Klipad50
  * [GPIO naming](gpio_naming.html)
  * Replaced [WiFi antenna](wifi.html)

## [Firmware](firmware.html)

## [Custom firmware options](firmware_custom.html)
  * [Archive](custom_firmware_archive.html)
    * Armbian mainline v25.2 (MKS-PI)
      * [Rebuilding (MKS-PI v25.2)](armbian-mkspi-mainline-setup-v25-2.html)
      * [Sovolized Armbian Klipper Image (MKS-PI v25.2)](armbian-mkspi-mainline-image-v25-2.html)
    * Armbian v24.2
      * [Rebuilding (MKS-PI v24.2)](armbian-mkspi-setup-v24-2.html)
      * [Sovolized Armbian Klipper Image (MKS-PI v24.2)](armbian-mkspi-image-v24-2.html)

## [Original firmware (by Sovol)](firmware_sovol.html)
  * [Where to download](firmware.html#where-to-download)
  * [Updating](updating.html)
    * [Update manager](updating.html#update-manager)
    * [Problems](updating.html#problems)
      * [System / Kernel (black screen)](updating.html#system--kernel-black-screen)
      * [Klipper-0.12.80+ (secondary mcu update)](updating.html#klipper-01280-secondary-mcu-update)
      * [Armbian Buster: End Of Life](updating.html#armbian-buster-end-of-life)
      * [KlipperScreen / Python 3.8](updating.html#klipperscreen--python-38)
      * [Moonraker Timelapse](updating.html#moonraker-timelapse)

## [Modifications by Sovol](sovol_mods.html#modifications_by_sovol)
  * [Files in /root](sovol_mods.html#files-in-root)
  * [Services:](sovol_mods.html#services)
    * [makerbase-auto-fresh.service](sovol_mods.html#makerbase-auto-freshservice)
    * [makerbase-automount@.service](sovol_mods.html#makerbase-automountservice)
    * [makerbase-beep.service](sovol_mods.html#makerbase-beepservice)
    * [makerbase-byid.service](sovol_mods.html#makerbase-byidservice)
    * [makerbase-net-mods.service](sovol_mods.html#makerbase-net-modsservice)
    * [makerbase-soft-shutdown.md.service](sovol_mods.html#makerbase-soft-shutdownservice)
    * [makerbase-timezone-monitor.service](sovol_mods.html#makerbase-timezone-monitorservice)
    * [makerbase-wlan0.service](sovol_mods.html#makerbase-wlan0service)
  * [reverting](sovol_mods.html#reverting)
    * [power loss recovery (plr)](sovol_mods.html#power-loss-recovery-plr-1)

## [Updating Klipper](updating_klipper.html)
  * [SD-card not accepted](updating_klipper.html#sd-card-not-accepted)

## [Configuring](configuring.html)
  * [Orca profiles](orca_profiles.html)
    * [joescalon SV06+ profile+buildplate](orca_profiles.html#joescalon-sv06-profilebuildplate)
      * [my (based on joescalon)](orca_profiles.html#my-based-on-joescalon)
      * [Modified buildplate texture](orca_profiles.html#my-based-on-joescalon)
    * [joescalon SV07+ profile+buildplate](orca_profiles.html#joescalon-sv07-profilebuildplate)
    * [Christian Vicks profiles](orca_profiles.html#christian-vicks-profiles)
    * [Automatic z-offset adjustment per filament](orca_profiles.html#automatic-z-offset-adjustment-per-filament)
  * [Beeper](beeper.html) macro (for use inKlipper)
  * [Extending storage space for gcode files](gcode_storage.html#expand-g-code-storage-space)
  * [Screen rotation](screen.html) for KlipperScreen/Xorg
  * [Status LEDs](status_leds.html) customization
  * [Timezone](timezone.html) configuration
    * [Timezone updates spamming syslog](timezone.html#sovol-image-timezone-updates-spamming-syslog)


## Troubleshooting

### Boot loops / Black screen ("unbricking")
  * [Boot loops / Black screen](bootloop.html)
    * [Some causes for the looping boot animation](bootloop.html#some-causes-for-the-looping-boot-animation)
    * [Typical causes for the damaged files](bootloop.html#typical-causes-for-the-damaged-files)
    * [Some causes for a black screen](bootloop.html#some-causes-for-a-black-screen)
    * [Fixes](bootloop.html#fixes)
      * [Cleaning up "saved_variables.cfg"](bootloop.html#cleaning-up-saved_variablescfg)
      * [Factory reset using Sovol's "armbian-update.deb"](bootloop.html#factory-reset-using-sovols-armbian-updatedeb)
      * [Full reflash of the eMMC using Sovol's KLIPAD50_IMAGE](bootloop.html#full-reflash-of-the-emmc-using-sovols-klipad50_image)

### [Getting access / Log in](access.html)
  * [Serial (over USB)](access.html#serial-over-usb)
  * [USB-Keyboard](access.html#usb-keyboard)
  * [SSH (or putty)](access.html#ssh-putty)

### Booting
  * [Booting from external device](booting.html)
    * [Boot the same image from an USB-stick](booting.html#boot-the-same-image-from-an-usb-stick)
    * [Boot image from USB-stick via serial console](booting.html#boot-image-from-usb-stick-via-serial-console)
    * [Boot from USB-stick with unbootable eMMC](booting.html#boot-from-usb-stick-with-unbootable-emmc)

## Klipper Shutdown
  * Scripts to safely shutdown.md klipper and power off using HS110 wifi.md power plug
    * [Windows version](shutdown.html)
    * [Linux version](shutdown_linux.html)

