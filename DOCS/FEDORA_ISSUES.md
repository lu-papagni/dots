A partire dalla versione `37` di Fedora, l'ISO potrebbe fallire l'avvio su specifiche schede madri quando si sceglie
l'installazione UEFI (ovviamente dovevo avere la scheda madre non compatibile...).
Mentre il problema viene risolto è possibile seguire questo _workaround_:
1. Scaricare la [ISO](https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/36/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-36-1.5.iso) di Fedora 36
2. Installarla normalmente
3. Ad installazione compiuta:
    1. Aggiornare il sistema con `sudo dnf upgrade --refresh`.
    2. Installare il plugin per l'avanzamento di versione: `sudo dnf install dnf-plugin-system-upgrade`.
    3. Scaricare l'aggiornamento più recente: `sudo dnf system-upgrade download --releasever=xx` dove `xx` sta al posto del numero di versione.
    4. Installare l'aggiornamento con `sudo dnf system-upgrade reboot`.
    5. Ripetere il _punto 3_ fino a che non si raggiunge la versione voluta.
> [!IMPORTANT]
> Secondo la [wiki](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-offline/#sect-how-many-releases-can-i-upgrade-across-at-once)
> di Fedora è sicuro eseguire un upgrade solo fino a 2 versioni successive. Serviranno quindi più passaggi per completare il workaround.

