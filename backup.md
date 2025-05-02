---
title: eMMC Card Backup
layout: page
parent: Configuring
nav_order: 3
---
# eMMC Card Backup
{: .no_toc }
### Contents:
{: .no_toc }
- TOC
{:toc}
----

## Backup the eMMC using an eMMC-USB adapter
- This is the fastest, easiest and most reliable way
- Follow [Gergo's Youtube guide](https://www.youtube.com/watch?v=PrC8zaVCHys)

## Backup eMMC to USB pen without eMMC-USB adapter
**(also without opening the KlipperScreen)**

### Requirements
- USB pen drive bigger than the eMMC card\
  (the default eMMC card is 8GB, use at least a 16GB pen drive)
- KlipperScreen with active makerbase-automount.service\
  (this is the default for the original Sovol image and my klipperized Armbian images)
- Reliable network connection (the backup will stop uncompleted when network connection drops too early)

### Prepare the USB pen drive
- Format an USB pen drive with "exFAT"
  - Do NOT use FAT32, it doesn't support the large files
  - Do NOT use NTFS, as its implementation is very slow
- Create an empty directory on that drive called "mksbackup"\
  (this is required to identify the correct drive).

### Download "plink.exe" from the "putty" suite
- Download location: <https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html>
  - If unsure, use the 32bit x86 version.
  - If the 32bit x86 version can't be executed, use the 64bit x86 version.

### Create following file in the same directory as plink.exe
- Call it e.g. "mksbackup.cmd"
- Or download the [mksbackup.cmd](files/mksbackup.cmd)
- Make sure it is in the same directory as plink.exe
- If the KlipperScreen can not be found with the name "mkspi" on your network,
  then modify the line `set HOST=mkspi` and replace "mkspi" with the IP-address of the KlipperScreen (as seen on the network panel).
- If you have changed the root password, then adjust the line `set PASS=makerbase` accordingly.

```
setlocal
set HOST=mkspi
set USER=root
set PASS=makerbase

plink %HOST% -l %USER% -pw %PASS% ^
  "for BASE in $(grep gcodes\/USB /proc/mounts|cut -d ' ' -f 2); "^
    "do BKDIR=$BASE/mksbackup; if [ -d $BKDIR ]; then "^
      "echo FOUND: $BKDIR ; "^
      "mount / -o remount,rw ;"^
      "dd if=/dev/mmcblk1 of=$BKDIR/$(date +%%Y%%m%%d-%%H%%M).img status=progress "^
      "&& poweroff ; break ;"^
    "fi ;"^
  "done"

endlocal
```

### Start the backup process
- Do NOT have any print jobs running on that KlipperScreen!
- Insert the USB pen drive into the (running) KlipperScreen.
- Execute the "mksbackup.cmd" on your local PC (e.g. with a doubleclick).
- Watch the progress of the backup process\
  (it will just bail out, if the pen drive could not be indentified).
- After the backup is done, the KlipperScreen is shut down automatically.\
  (The final line will read `FATAL ERROR: Remote side unexpectedly closed network connection`\
   this is intended behaviour, nothing to worry about).

### Wait for the backup to finish
- When the KlipperScreen has shut down, remove the USB pen drive.
- The backed up image can be found in the "mksbackup" directory.
- The filename will reflect the date and time when the backup was started.

### Check the completeness of the backup file
- If the network connection broke during the backup, the backup will be incomplete!
- If the KlipperScreen did not shut down after the backup, then network connection probably did break too early.
- Best is to use an eMMC-USB adapter at least once to backup the eMMC card, to find out the correct size.
  Once you know that correct size, you can compare it to the size of the later backups done with "mksbackup.cmd".
  If the sizes differ, then something went wrong.

Example output:
```
d:\putty>mksbackup.cmd

d:\putty>setlocal

d:\putty>set HOST=mkspi

d:\putty>set USER=root

d:\putty>set PASS=makerbase

d:\putty>plink mkspi -l root -pw makerbase   "for BASE in $(grep gcodes\/USB /proc/mounts|cut -d ' ' -f 2); "    "do BKDIR=$BASE/mksbackup; if [ -d $BKDIR ]; then "      "echo FOUND: $BKDIR ; "      "mount / -o remount,rw ;"      "dd if=/dev/mmcblk1 of=$BKDIR/$(date +%Y%m%d-%H%M).img status=progress "      "&& poweroff ; break ;"    "fi ;"  "done"
Server refused our key
FOUND: /home/mks/printer_data/gcodes/USB/mksbackup
7817642496 bytes (7.8 GB, 7.3 GiB) copied, 565 s, 13.8 MB/s
15269888+0 records in
15269888+0 records out
7818182656 bytes (7.8 GB, 7.3 GiB) copied, 565.029 s, 13.8 MB/s
FATAL ERROR: Remote side unexpectedly closed network connection

d:\putty>endlocal

d:\putty>
```
