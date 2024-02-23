#!/usr/bin/env bash

# Colori
HI_DIM="\e[1;30m"    # Grigio
HI_WARN="\e[1;33m"   # Giallo
HI_OK="\e[1;32m"     # Verde
HI_ERR="\e[1;31m"    # Rosso
HI_RST="\e[0m"       # Reset
HI_INV="\e[7m"       # Inverti
HI_UND="\e[4m"       # Sottolinea

# Decorazioni di linea
LI_INFO="$HI_OK::$HI_RST"
LI_INPUT="$HI_WARN::$HI_RST"
LI_ERROR="$HI_ERR::$HI_RST"
