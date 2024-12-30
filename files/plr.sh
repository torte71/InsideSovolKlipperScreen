#!/bin/bash
mkdir -p ~/printer_data/gcodes/plr
filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/mks/printer_data/config/saved_variables.cfg)
filepath=$(printf "$filepath")
echo "filepath=$filepath"
last_file=$(sed -n "s/.*last_file *= *'\([^']*\)'.*/\1/p" /home/mks/printer_data/config/saved_variables.cfg)
last_file=$(printf "$last_file")
echo "$last_file"
plr=$last_file
height=$(sed -n "s/.*power_resume_z *= *\([^']*\).*/\1/p" /home/mks/printer_data/config/saved_variables.cfg)
echo "height=$height"
echo "plr=$plr" 
PLR_PATH=~/printer_data/gcodes/plr
file_content=$(cat "${filepath}" | sed '/; Sovol3D thumbnail begin/,/; Sovol3D thumbnail end/d')
# comment_content=$(grep '^;' "${filepath}" | sed '/;Generated with Sovol/q')
comment_content=$(grep '^;' "${filepath}" | sed '/; Sovol3D thumbnail end/q')
echo "$file_content" | sed  's/\r$//' | awk -F"Z" 'BEGIN{OFS="Z"} {if ($2 ~ /^[0-9]+$/) $2=$2".0"} 1' > /home/mks/plrtmpA.$$
echo "$comment_content" > ${PLR_PATH}/"${plr}"

grep ';TIME:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"

grep ';Layer height:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINX:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINY:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINZ:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXX:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXY:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXZ:' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
# layerheight=$(grep ';Layer height:' $filepath | awk -F':' '{print $2}' | tr -d ' ')
grep ';Generated with Sovol Slicer' /home/mks/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
echo "SET_KINEMATIC_POSITION Z=$height" >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed -e '1,/G0.* Z'"${1}"'/ {/Z'"${1}"'/!d}' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\).*/SET_KINEMATIC_POSITION Z=\1/p' >> ${PLR_PATH}/"${plr}"
echo 'M118 START_TEMPS...' >> ${PLR_PATH}/"${plr}"
BG_EX=`tac /home/mks/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -e '/ Z[0-9]/ q' | tac | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
# If we failed to match an extrusion command (allowing us to correctly set the E axis) prior to the matched layer height, then simply set the E axis to the first E value present in the resemued gcode.  This avoids extruding a huge blod on resume, and/or max extrusion errors.
if [ "${BG_EX}" = "" ]; then
    BG_EX=`tac /home/mks/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' | sed -e '/ E[0-9]/ q' | sed -ne 's/.* E\([^ ]*\)/G92 E\1/p'`
fi
echo ${BG_EX} >> ${PLR_PATH}/"${plr}"
echo 'M109 S152' >> ${PLR_PATH}/"${plr}"
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z9.9999' >> ${PLR_PATH}/"${plr}"
echo 'G28 X Y' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed '/ Z'${1}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/mks/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z-2.9999' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
echo 'M106 S255' >> ${PLR_PATH}/"${plr}"
tac /home/mks/plrtmpA.$$ | sed -e '/ Z'${1}'[^0-9]*$/q' | tac | tail -n+1  | sed -ne '/ Z/,$ p' >> ${PLR_PATH}/"${plr}"
rm /home/mks/plrtmpA.$$
