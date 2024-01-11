#!/usr/bin/env bash
if grep -q open /proc/acpi/button/lid/LID/state; then
  hyprctl keyword monitor "eDP-1, disable"
else
  hyprctl keyword monitor "eDP-1,1920x1080@60,auto,1"
fi

