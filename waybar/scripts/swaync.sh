#!/usr/bin/env bash
PAUSED="$(swaync-client --get-dnd)"
if [ "$PAUSED" == 'false' ]; then
  COUNT="$(swaync-client -c)"
  if [ "$COUNT" != '0' ]; then
    TEXT="$COUNT"
    ALT="pending"
    CLASS="pending"
    TOOLTIP="$COUNT pending"
  else
    ALT="empty"
    CLASS="empty"
    TOOLTIP="No pending notifications"
    TEXT=""
  fi
else
  TEXT=""
  CLASS="disabled"
  ALT="dnd"
  TOOLTIP="Do Not Disturb ON"
fi
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}\n' "$TEXT" "$ALT" "$TOOLTIP" "$CLASS"
