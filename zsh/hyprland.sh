# Esegui Hyprland dopo il login da tty1
if [ "$(tty)" = "/dev/tty1" ]; then
  which "Hyprland" > /dev/null
  if [ $? -eq 0 ]; then
    exec Hyprland
  else
    echo "Hyprland non installato!"
  fi
fi
