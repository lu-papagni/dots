#!/usr/bin/env bash

# rende il testo grigio
function DimText {
    echo "$HI_DIM$1$HI_RST"
}

# sottolineatura
function UnderlineText {
    echo "$HI_UND$1$HI_RST"
}

# crea una scritta di warning
function WarnText {
    echo -e "$HI_WARN""WARNING> $1$HI_RST"
}

# crea una scritta di errore
function ErrText {
    echo -e "\e[1;31m"
}

# crea una scritta di suggerimento
function TipText {
    echo -e "$HI_OK""TIP> $1$HI_RST"
}

function WithPrivilege {
    case "$1" in
        "dnf" | "pacman")
            echo "sudo $1"
            ;;
        "yay")
            echo "$1"
            ;;
        *)
            exit 1
            ;;
    esac
}

# esegue o mostra in versione debug un comando
function Run {
    if [ "$DEBUG" != true ]; then
        $1
    else
        if [[ "$DEBUG" = true || "$LOG_ENABLED" = true ]]; then
            echo -e "$(DimText 'DEBUG>') $1"
        fi
    fi
}

function PrintUsage {
    echo "
    |---------------------------------------------| GUIDA RAPIDA |----------------------------------------------|
    |  Comandi disponibili:                                                                                     |
    |  -d    ->    Modalità debug: i comandi non vengono eseguiti ma mostrati a schermo                         |
    |  -s    ->    Non controlla se sono installati tutti i programmi necessari al funzionamento dello script.  |
    |              È utile da usare in combinazione con -d                                                      |
    |  -h    ->    Aiuto: mostra questo messaggio.                                                              |
    |  -l    ->    Abilita il logging. I comandi verranno prima mostrati a schermo come nel debug e poi         |
    |              eseguiti.                                                                                    |
    |                                                                                                           |
    |  NB: questo messaggio viene mostrato anche se la sintassi dei parametri è errata.                         |
    |-----------------------------------------------------------------------------------------------------------|
    "
}
