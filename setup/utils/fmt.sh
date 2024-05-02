# Codici per output colorato
__FMT="\e["
FMT_OFF="$__FMT""0m"
FMT_MAGENTA="$__FMT""35m"
FMT_RED="$__FMT""31m"

function PrintLog ()
{
  local STR="$1"
  echo -e "$FMT_MAGENTA[SETUP]$FMT_OFF $STR"
}

function PrintErr ()
{
  local STR="$1"
  echo -e "$FMT_RED[ERROR] $(PrintLog "$STR")"
}

