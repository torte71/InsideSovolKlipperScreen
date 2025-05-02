setlocal
set HOST=mkspi
set USER=root
set PASS=makerbase

plink %HOST% -l %USER% -pw %PASS% ^
  "for BASE in $(grep gcodes\/USB /proc/mounts|cut -d ' ' -f 2); "^
    "do BKDIR=$BASE/mksbackup; if [ -d $BKDIR ]; then "^
      "echo FOUND: $BKDIR ; "^
      "mount / -o remount,ro ;"^
      "dd if=/dev/mmcblk1 of=$BKDIR/$(date +%%Y%%m%%d-%%H%%M).img status=progress "^
      "&& poweroff ; break ;"^
    "fi ;"^
  "done"

endlocal
