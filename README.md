# Installazione
## Fedora
- Scaricare la versione [Everything](https://alt.fedoraproject.org).
- Alla richiesta di creare un utente root scegliere **NO**.

### Possibili problemi
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

## Arch-based
- [Arch Linux](https://archlinux.org/download/) usando lo script `archinstall`
- [EndeavourOS](https://endeavouros.com/#Download) (consigliato)

### Possibili problemi
- **Non c'è l'opzione per usare Wayland su KDE** ➡️ installare il pacchetto `plasma-wayland-session`
> [!NOTE]
> Da KDE `6.0` non è più necessario installare `plasma-wayland-session` in quanto Wayland è supportato di default.

- **L'installazione di alcuni language server per Neovim fallisce**  sono stati osservati 2 casi fino ad ora. Le soluzioni sono
    1.  Installare `nodejs` e `npm` in quanto sono dipendenze di parecchi script di `mason.nvim` (gestore language server).
    2.  Installare `unzip` se l'errore è provocato da `clangd`, server per C/C++.

- **Il login manager non compare dopo l'installazione** ➡️ attivare il servizio relativo con `systemctl`.
Per [SDDM](https://wiki.archlinux.org/title/SDDM) usare

- **Il sistema non entra in sospensione**
Se il desktop environment è KDE ed è stato installato `rclone` per connettersi ad un drive di rete, il problema è
probabilmente correlato all'indicizzatore `baloo`.
Per risolvere:
    1. Recarsi in `Impostazioni > Ricerca > Ricerca File`
    2. In `Posizioni` aggiungere alle eccezioni la cartella sincronizzata con `rclone`.
    3. Riavviare il sistema o effettuare il logout, quindi nuovamente il login.

```bash
systemctl enable sddm.service
```

# Configurazione
## Dotfiles
Usare l'apposito [script](https://github.com/lu-papagni/setup-script) seguendo le istruzioni
nel file README.

> [!WARNING]
> Per utilizzarlo è necessaria una <ins>shell POSIX</ins> come `bash`, `zsh`, ecc.
> Altre shell (ad esempio `fish`) non sono in grado di eseguirlo.

## Firewall
Nella distribuzione potrebbe essere installato `firewalld`.
Per impostazione predefinita il software blocca tutti i tipi di pacchetto sulla rete. Questo potrebbe creare problemi specialmente
durante le operazioni di stampa e accesso a dichi di rete.
- **Servizio di stampa** ➡️ attivare `ipp-client`
- **Condivisione file con SAMBA** ➡️ attivare `samba-client`

Firewalld permette di definire delle "zone" in cui attivare specifiche regole.
È consigliabile utilizzare la zona _home_ per abilitare le regole elencate in precedenza.
Infine è necessario aggiungere la rete desiderata alla zona _home_ per rendere effettive le modifiche.

## Discord
Discord non rileva di default la presenza dei _desktop portals_, necessari per condividere lo schermo.
Per correggere il problema basta eseguire il programma esportando la variabile d'ambiente `XDG_SESSION_TYPE=x11`.

# Extra
- Configurazione del filesystem [BTRFS](https://github.com/lu-papagni/dots/blob/main/DOCS/BTRFS.md)
- Breve guida ai [gestori delle finestre](https://github.com/lu-papagni/dots/blob/main/DOCS/WINDOW_MANAGERS.md)
