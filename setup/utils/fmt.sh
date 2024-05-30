# Codici per output colorato
__FMT="\e["
FMT_OFF="$__FMT""0m"
FMT_MAGENTA="$__FMT""35m"
FMT_RED="$__FMT""31m"
FMT_YELLOW="$__FMT""33m"

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

function PrintInfo ()
{
  local STR="$1"
  echo -e "$FMT_YELLOW[INFO] $(PrintLog "$STR")"
}
