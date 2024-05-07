#!/usr/bin/env bash
STATE="/proc/acpi/button/lid/LID0/state"
if cat $STATE | grep -q "closed";  then
  echo "Disabilita"
  hyprctl keyword monitor "eDP-1, disable"
else
  echo "Abilita"
  hyprctl keyword monitor "eDP-1,1920x1200@60,auto,1.25"
fi

