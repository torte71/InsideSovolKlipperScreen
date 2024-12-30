# General 3D printing

## Slicing / Design
  * [Orca profiles](orca_profiles.md)
    * [joescalon SV06+ profile+buildplate](orca_profiles.md#joescalon-sv06-profilebuildplate)
      * [my (based on joescalon)](orca_profiles.md#my-based-on-joescalon)
      * [Modified buildplate texture](orca_profiles.md#my-based-on-joescalon)
    * [joescalon SV07+ profile+buildplate](orca_profiles.md#joescalon-sv07-profilebuildplate)
    * [Christian Vicks profiles](orca_profiles.md#christian-vicks-profiles)
  * [Automatic z-offset adjustment per filament](orca_profiles.md#automatic-z-offset-adjustment-per-filament)

## Klipperized Sovol SV06+/SV07+ (mostly)

### [Firmware](firmware.md)
  * [Where to download](firmware.md#where-to-download)
  * [SD-card not accepted](firmware.md#sd-card-not-accepted)

### Klipper Shutdown
  * Scripts to safely shutdown.md klipper and power off using HS110 wifi.md power plug
    * [Windows version](shutdown.md)
    * [Linux version](shutdown_linux.md)

## Sovol KlipperScreen (Makerbase MKS KLIPAD50)

### [Modifications by Sovol](sovol_mods.md#modifications_by_sovol)
  * [Files in /root](sovol_mods.md#files-in-root)
  * [Services:](sovol_mods.md#services)
    * [makerbase-auto-fresh.service](sovol_mods.md#makerbase-auto-freshservice)
    * [makerbase-automount@.service](sovol_mods.md#makerbase-automountservice)
    * [makerbase-beep.service](sovol_mods.md#makerbase-beepservice)
    * [makerbase-byid.service](sovol_mods.md#makerbase-byidservice)
    * [makerbase-net-mods.service](sovol_mods.md#makerbase-net-modsservice)
    * [makerbase-soft-shutdown.md.service](sovol_mods.md#makerbase-soft-shutdownservice)
    * [makerbase-timezone-monitor.service](sovol_mods.md#makerbase-timezone-monitorservice)
    * [makerbase-wlan0.service](sovol_mods.md#makerbase-wlan0service)
  * [reverting](sovol_mods.md#reverting)
    * [power loss recovery (plr)](sovol_mods.md#power-loss-recovery-plr-1)

### [Updating](updating.md)
  * [Update Manager](updating.md#update-manager)
  * [Problems](updating.md#problems)
    * [System / Kernel (black screen)](updating.md#system--kernel-black-screen)
    * [Klipper-0.12.80+ (secondary mcu update)](updating.md#klipper-01280-secondary-mcu-update)
    * [Armbian Buster: End Of Life](updating.md#armbian-buster-end-of-life)
    * [KlipperScreen / Python 3.8](updating.md#klipperscreen--python-38)
    * [Moonraker Timelapse](updating.md#moonraker-timelapse)

### [Configuring](configuring.md)
  * [Logging, etc.](configuring.md#logging-etc)
    * [Timezone updates spamming syslog](configuring.md#timezone-updates-spamming-syslog)

### Boot loops / Black screen ("unbricking")
  * [Boot loops / Black screen](bootloop.md)
    * [Some causes for the looping boot animation](bootloop.md#some-causes-for-the-looping-boot-animation)
    * [Typical causes for the damaged files](bootloop.md#typical-causes-for-the-damaged-files)
    * [Some causes for a black screen](bootloop.md#some-causes-for-a-black-screen)
    * [Fixes](bootloop.md#fixes)
      * [Cleaning up "saved_variables.cfg"](bootloop.md#cleaning-up-saved_variablescfg)
      * [Factory reset using Sovol's "armbian-update.deb"](bootloop.md#factory-reset-using-sovols-armbian-updatedeb)
      * [Full reflash of the eMMC using Sovol's KLIPAD50_IMAGE](bootloop.md#full-reflash-of-the-emmc-using-sovols-klipad50_image)

### Expand G-Code storage space
  * [Extending storage space for gcode files](gcode_storage.md#expand-g-code-storage-space)

### Wifi
  * [Better wifi antenna](wifi.md)

### Beeper
  * [Beeper](beeper.md)

### Screen
  * [Rotation](screen.md)

### [Getting Access / Log In](access.md)
  * [Serial (over USB)](access.md#serial-over-usb)
  * [USB-Keyboard](access.md#usb-keyboard)
  * [SSH (or putty)](access.md#ssh-putty)

### Booting
  * [Booting from external device](booting.md)
    * [Boot the same image from an USB-stick](booting.md#boot-the-same-image-from-an-usb-stick)
    * [Boot image from USB-stick via serial console](booting.md#boot-image-from-usb-stick-via-serial-console)
    * [Boot from USB-stick with unbootable eMMC](booting.md#boot-from-usb-stick-with-unbootable-emmc)

### [Rebuilding](rebuilding.md)
  * [Base system](rebuilding.md#base-system)
  * [Klipper](rebuilding.md#klipper)
  * [Sovol mods](rebuilding.md#sovol-mods)
  * [Internal wifi.md + spi-dev](rebuilding.md#internal-wifi--spidev)

### Image
  * [Sovolized Armbian Klipper Image](image.md)
