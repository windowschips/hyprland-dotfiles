#!/usr/bin/env bash

shutdown='󰐥'
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'
yes='󰄬'
no='󰅖'

confirm() {
	echo -e "$yes\n$no" | rofi \
		-theme-str 'window {location: center; anchor: center; fullscreen: false; width: 300px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg "Are you sure?" \
		-theme ~/.dotfiles/home/.config/rofi/powermenu.rasi
}

menu() {
	killall rofi;
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi -dmenu -theme ~/.dotfiles/home/.config/rofi/powermenu.rasi
}

chosen="$(menu)"
if [[ -z "$chosen" ]]; then
	exit 0
fi

selected="$(confirm)"
if [[ "$selected" == "$yes" ]]; then
	case ${chosen} in
		$shutdown)
			systemctl poweroff
			;;
		$reboot)
			systemctl reboot
			;;
		$lock)
			hyprlock
			;;
		$suspend)
			mpc -q pause;
			amixer set Master mute;
			systemctl suspend;
			;;
		$logout)
			hyprctl dispatch exit
			;;
	esac
fi 