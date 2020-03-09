#!/bin/bash
echo "livearch init"
function spacr() {
    for i in {1..$1}; do
        echo ""
    done
}
echo ""
echo "Setting keymap"
loadkeys no-latin1
echo "Extending live root partition"
read -p "Root fs size: "
mount -o remount,size=4G

echo ""
echo "Fetching packages"
pacman -Syy
pacman -S pacman-contrib


