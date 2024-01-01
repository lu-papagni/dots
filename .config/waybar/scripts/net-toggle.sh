WIFI="$(nmcli device show | awk '$1 == "GENERAL.DEVICE:" {print $2}' | grep '^w' | tr -d '\n')"
CURRENT="$(nmcli -t -f DEVICE connection show --active | head -n 1)"
# CURRENT == "lo" == loopback => disconnesso
if [[ "$CURRENT" == "lo" ]] then 
  nmcli d connect $WIFI
else
  nmcli d disconnect $WIFI
fi
