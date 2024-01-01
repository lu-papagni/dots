if [ "$(bluetoothctl show | grep -oP 'PowerState: \K\w+')" = "on" ]; then
  bluetoothctl power off
else
  bluetoothctl power on
fi
