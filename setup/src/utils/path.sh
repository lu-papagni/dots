#!/usr/bin/env bash

if [ ! -v __DEFINE_PATHUTILS ]; then
  __DEFINE_PATHUTILS=true

  function GetScriptDir ()
  {
    echo "$(cd `dirname $0` && pwd)"
  }

  function GetDotsDir ()
  {
    echo "$(cd "$(GetScriptDir)" && cd .. && pwd)"
  }

fi
