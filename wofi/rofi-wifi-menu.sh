#!/usr/bin/env bash

notify-send -t 4000 "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g | sed -n '2 p')
if [[ "$connected" == *"disabilitato"* ]]; then
	toggle="󰖩  Attiva Wi-Fi"
elif [[ "$connected" == *"abilitato"* ]]; then
	toggle="󰖪  Disattiva Wi-Fi"
else
  echo "$connected"
fi

# Use wofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | wofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " )
# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Attiva Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disattiva Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="Sei connesso alla rete \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successo" && notify-send -t 3000 "Connessione stabilita" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(wofi -dmenu -p "Password: " )
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successo" && notify-send -t 3000 "Connessione stabilita" "$success_message"
	fi
fi
