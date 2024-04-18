#!/bin/bash

## Confirm

function ync() {
	while true
	do
		read -n 1 -r -p "[y/n]" input1

		case $input1 in
			[yY])
		input1a="y"
		break
		;;
			[nN])
		input1a="n"
		break
		;;
			*)
		echo ""
		echo "Invalid input..."
		;;
		esac
	done
}


echo ""
echo "livearch init"

## Set keymap
echo ""
echo "Setting keymap"
read -r -p "Set keymap: [no-latin1]" skm
if [[ -z $skm ]]
then
	loadkeys de
else
	loadkeys $skm
	if [[ $? != "0" ]]
	then
		echo "Error setting keymap, try doing it manually!"
	fi
fi

echo "Extending live root partition"
while true
do
	echo "Set root partition size, in G if not specified. (1 = 1G, 1M = 1M) [#K/M/G]"
	read -p "Root fs size: " setsizefs
	if [[ $setsizefs =~ ^[0-9]+$ ]]
	then
		mount -o remount,size=${setsizefs}G /run/archiso/cowspace
		break
	elif [[ $setsizefs =~ ^[0-9]+[KMG]$ ]]
	then
		mount -o remount,size=${setsizefs} /run/archiso/cowspace
		break
	else
		echo ""
		echo "Error, try again!"
	fi
done

echo ""
echo "Fetching packages"
pacman -Syy
pacman -S pacman-contrib --noconfirm
echo "Rank mirrors? "

ync
if [[ $input1a =~ [y] ]]
then
	echo "Ranking mirrors based on speed"
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.back
	rankmirrors -n 5 -m 1.5 -v /etc/pacman.d/mirrorlist.back | tee /etc/pacman.d/mirrorlist
fi

echo "Installing basepackages"
pacman -S i3 dmenu xorg-xinit xorg-server xorg-xrandr arandr firefox ttf-dejavu terminator tmux dbus xf86-video-intel --noconfirm

echo 'exec /usr/bin/i3' > ~/.xinitrc
passwd

echo ""
echo "Start i3?"
ync
if [[ $input1a =~ [y] ]]
then
	startx
fi







