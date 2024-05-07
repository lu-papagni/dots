# Installazione
## Fedora
- La [versione](https://alt.fedoraproject.org) da installare è _Fedora Everything_ per [Hyprland](#hyprland), oppure [Fedora KDE](https://fedoraproject.org/spins/kde) per [KWin](#kwin).
- Se l’installazione non dovesse partire, provare ad avviare l’immagine ISO in modalità grafica ridotta.
- Alla richiesta di creare un utente root scegliere **NO**.

### Possibili problemi
A partire dalla versione `37` di Fedora, l'ISO potrebbe fallire l'avvio su specifiche schede madri quando si sceglie l'installazione UEFI (ovviamente dovevo avere la scheda madre non compatibile...). Mentre il problema viene risolto è possibile seguire questo _workaround_:
1. Scaricare la [ISO](https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/36/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-36-1.5.iso) di Fedora 36
2. Installarla normalmente
3. Ad installazione compiuta:
    1. Aggiornare il sistema con `sudo dnf upgrade --refresh`.
    2. Installare il plugin per l'avanzamento di versione: `sudo dnf install dnf-plugin-system-upgrade`.
    3. Scaricare l'aggiornamento più recente: `sudo dnf system-upgrade download --releasever=xx` dove `xx` sta al posto del numero di versione.
    4. Installare l'aggiornamento con `sudo dnf system-upgrade reboot`.
    5. Ripetere il _punto 3_ fino a che non si raggiunge la versione voluta.
> [!IMPORTANT]
> Secondo la [wiki](https://docs.fedoraproject.org/en-US/quick-docs/upgrading-fedora-offline/#sect-how-many-releases-can-i-upgrade-across-at-once) di Fedora è sicuro eseguire un upgrade solo fino a 2 versioni successive. Serviranno quindi più passaggi per completare il workaround.

## Arch-based
- [Arch Linux](https://archlinux.org/download/) usando lo script `archinstall`
- [EndeavourOS](https://endeavouros.com/#Download)

### Possibili problemi
- **Non c'è l'opzione per usare Wayland su KDE** ➡️ installare il pacchetto `plasma-wayland-session`
> [!NOTE]
> Da KDE `6.0` non è più necessario installare `plasma-wayland-session` in quanto Wayland è supportato di default.
- **L'installazione di alcuni language server per Neovim fallisce** ➡️ sono stati osservati 2 casi fino ad ora. Le soluzioni sono
    1.  Installare `nodejs` e `npm` in quanto sono dipendenze di parecchi script di `mason.nvim` (gestore language server).
    2.  Installare `unzip` se l'errore è provocato da `clangd`, server per C/C++.
- **Il login manager non compare dopo l'installazione** ➡️ attivare il servizio relativo con `systemctl`. Per [SDDM](https://wiki.archlinux.org/title/SDDM) usare

```bash
systemctl enable sddm.service
```

# Configurazione
## Dotfiles
La maggior parte delle impostazioni dei software su Linux è salvata nei loro rispettivi file di configurazione (chiamati _dotfiles_).
Questi ultimi sono salvati [qui](https://github.com/lu-papagni/dots).

Per gestire i _dotfiles_ più facilmente ho creato lo script [setup.sh](https://raw.githubusercontent.com/lu-papagni/dots/main/setup/setup.sh)
per eseguire tutte le operazioni ripetitive, come collegamenti simbolici e installazione dei pacchetti.

> [!WARNING]
> Per utilizzare `setup.sh` è necessaria una <ins>shell compatibile con lo standard POSIX</ins> come `bash`, `zsh`, ecc. Altre shell (ad esempio `fish`) non sono in grado di eseguirlo.

## Script di installazione
**Pre-requisiti**
- Aver clonato questa repository in una directory a piacere sul proprio PC. Questa directory non deve essere eliminata o spostata dopo l'installazione.
- Nello script, modificare la variabile `DOTS_DIR` in modo da puntare a quest'ultima directory. Per impostazione predefinita, lo script assume che sia `~/.dotfiles`.
- Concedere i permessi di esecuzione allo script con:
  ```bash
  chmod +x setup.sh
  ```

**Come si usa?**

È possibile aggiungere nell'array `SOURCES` una serie di nomi di file di testo (esclusa l'estensione) da cui lo script copierà i nomi dei pacchetti da installare.

> [!NOTE]
> Deve essere presente un solo pacchetto per riga.
> I file devono trovarsi nella directory `setup/sources`.

Nella prima riga è obbligatorio specificare il nome del package manager che dovrà installarli preceduto da un punto esclamativo, in questo modo: `!nome_package_manager`.

Fatto questo, basta avviare lo script dal terminale.

## Firewall
Nella distribuzione potrebbe essere installato `firewalld`. Per impostazione predefinita il software blocca tutti i tipi di pacchetto sulla rete, e questo potrebbe creare problemi specialmente
durante le operazioni di stampa e accesso a dichi di rete.
- **Servizio di stampa** ➡️ attivare `ipp-client`
- **Condivisione file con SAMBA** ➡️ attivare `samba-client`

Firewalld permette di definire delle _zone_ in cui attivare specifiche regole. È consigliabile utilizzare la zona _home_ per abilitare le regole elencate in precedenza.
Infine è necessario aggiungere la rete desiderata alla zona _home_ per rendere effettive le modifiche.

## Snapshot BTRFS
Se il sistema è stato configurato con il filesystem BTRFS, è possibile configurare la funzione degli snapshot del disco. Attivandola, il sistema potrà essere all'occorrenza
riportato ad uno stato funzionante nel caso in cui dovesse avvenire un malfunzionamento, come un aggiornamento che introduce un bug critico o corruzione dei dati.
Usare come riferimento i seguenti articoli:
1. [BTRFS snapshots and system rollbacks on Arch Linux - Daniel Wayne Armstrong](https://www.dwarmstrong.org/btrfs-snapshots-rollbacks/)
2. [EndeavourOS System Recovery - pavinjosdev](https://github.com/pavinjosdev/eos-system-recovery)

### Pre-requisiti
Avere installati i seguenti pacchetti:
- `snapper` ➡️ esegue gli snapshot
- `snap-pac` (opzionale) ➡️ hook di pacman che fa uno snapshot ogni volta che avviene un'installazione
- `grub-btrfs` ➡️ permette di accedere agli snapshot da grub
- `inotify-tools` ➡️ dipendenza di _grub-btrfs_

### Configurazione
1. Creare una configurazione per gli snapshot della root.
```bash
sudo snapper -c root create-config /
```
2. Verificare che sia stata creata correttamente la directory `/.snapshots`. Questo indica che il comando precedente è andato a buon fine.
```bash
sudo btrfs subvolume list /
```
L'output del comando precedente dovrebbe essere simile a
```
ID 256 gen 199 top level 5 path @
ID 257 gen 186 top level 5 path @home
ID 258 gen 9 top level 5 path @snapshots
[...]
ID 265 gen 199 top level 256 path .snapshots
```
Ora bisogna creare un nuovo sotto-volume btrfs per contenere gli snapshot. Snapper ha creato di default la directory `/.snapshots`, ma non l'ha separata dal contenuto
della root. In questo modo, se mai servisse effettuare un rollback, si andrebbero a perdere tutti gli snapshot fatti _dopo_ quello ripristinato.

3. Rimuovere e ricreare la cartella creata da snapper
```
sudo rm -rI /.snapshots && sudo mkdir /.snapshots
```

4. Montare la partizione btrfs e creare nuovo sotto-volume
```bash
sudo mount -t btrfs /dev/<partizione principale> /mnt    # solitamente è sda2, ma se si usa un nvme ha una nomenclatura diversa
sudo btrfs subvolume create /mnt/@snapshots
sudo umount /mnt
```

5. Modificare la tabella delle partizioni per montare automaticamente `@snapshots`. Aprire il file `/etc/fstab` e aggiungere in basso questa riga
```bash
UUID=<xxx-xxx-xxx-xxx-xxx>  /.snapshots  btrfs  subvol=/@snapshots,<opzioni di montaggio>
```
Al posto di `<xxx-xxx-xxx-xxx-xxx>` bisogna inserire l'ID comune alle altre partizioni btrfs presenti; le opzioni di montaggio possono essere copiate da quelle già usate
dalle altre partizioni.

6. Montare tutte le partizioni
```bash
sudo mount -a
```
Se dovesse apparire un _hint_ di systemd che chiede di riavviare i processi in background, farlo con
```bash
systemctl daemon-reload
```

7. Eseguire uno snapshot di prova per verificare che sia tutto a posto
```bash
sudo snapper -c root create -c number -d 'TEST'
# il parametro 'number' indica l'algoritmo con cui gli snapshot vengono via via eliminati
# il più vecchio viene eliminato per primo
```

8. Verificare che lo snapshot sia stato creato e che sia presente in `@snapshots`
```bash
sudo snapper -c root list   # e poi
sudo btrfs subvolume list /
```

9. Attivare il servizio che esegue uno snapshot ad ogni avvio
```bash
systemctl enable snapper-boot.timer
```

A questo punto è necessario configurare una modalità per accedere agli snapshot. Una soluzione è quella di usare una funzione chiamata _overlayfs_, la quale
permette di avviare uno snapshot come se fosse un CD live. In questo modo avremo accesso alla GUI, da cui potremo effettuare la manutenzione.

10. Modificare `/etc/grub.d/41_snapshots-btrfs` aggiungendo `rd.live.overlay.overlayfs=1` ai parametri del kernel (variabile `kernel_parameters`).
11. <ins>Eseguire il file appena modificato</ins>. Poi riconfigurare grub con
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

12. Per rendere questo processo automatico è possibile aggiungere questo servizio
```bash
sudo systemctl enable grub-btrfsd
```
> [!IMPORTANT]
> È comunque obbligatorio usare il procedimento manuale almeno una volta.

13. Aggiungere `/.snapshots` alle eccezioni durante l'indicizzazione del disco. Modificare `/etc/updatedb.conf`, aggiungendo la stringa `.snapshots` alla variabile `PRUNENAMES`.
14. Per effettuare la manutenzione, fare riferimento al paragrafo 11 dell'articolo 1 mostrato in precedenza.

# Gestore delle finestre
Su Linux si può scegliere l'ambiente grafico in modo molto libero. La prima decisione è sul tipo di gestore delle finestre (_window manager_ o _WM_ in breve) da usare, ovvero il software che posiziona
le finestre sullo schermo. In generale si dividono in due categorie: _stacking_ e _tiling_.

Come si comportano le finestre in queste due varianti?
- **Stacking**
    - si riaprono nell'ultimo posto dove sono state chiuse
    - possono sovrapporsi
    - hanno una barra del titolo con cui si possono spostare, minimizzare, ingrandire e chiudere.
- **Tiling**
    - sono gestite secondo un layout predefinito
    - vengono disegnate a partire da un punto specifico, come uno degli angoli dello schermo o in corrispondenza della finestra attiva.
    - Le finestre solitamente non si sovrappongono mai, a meno che non vengano spostate manualmente (quindi sganciate dal layout).
    - Per cambiare la finestra attiva, spostarla in un altro punto, ridimensionarla, chiuderla, ecc. si usano degli shortcut formati solitamente da un modificatore o _leader_ e altri tasti.

Generalmente, i WM stacking sono quelli più comuni e semplici da configurare. In più, portano con sé molti programmi pre-installati. Per dare un'idea, anche Windows ne usa uno di questo tipo.

I gestori tiling, invece, hanno meno funzionalità dell'altro tipo e sono più complicati da gestire. Sono davvero utili per chi lavora molto con il terminale e si trova ad avere spesso la necessità di
aprire/allineare più istanze per avere tutto sotto controllo. O per flexare 🗿.

| Due esempi |
|:--:|
| ![](https://www.html.it/app/uploads/2022/03/kde.png "Stacking window manager KDE") |
| *KWin, stacking* |
| ![](https://storage.googleapis.com/zenn-user-upload/38ff1f02ef60253135f77e14.png "Tiling window manager Sway") |
| *Sway, tiling* |

## KWin
È uno dei migliori window manager del tipo classico. In realtà fa parte di una suite di programmi molto più grande, cioè del _desktop environment_ KDE.

### Layout 1
![image](https://github.com/lu-papagni/dots/assets/89859659/b302cb5f-736a-4b2f-9882-9a7146296843)

- **Dock**: il dock (pannello che permette di lanciare le applicazioni) si trova in basso al centro. È un pannello fluttuante composto, in ordine, da questi widget:
    1.	Launcher applicazioni solo icone
    2.	Latte separator
    3.	Collegamento alla directory “cestino”

- **System tray**: è un pannello fluttuante (allineato a destra) composto da:
    1.	Applet cambia desktop
    2.	Latte separator
    3.	Monitor prestazioni (memoria)
    4.	Monitor prestazioni (cpu)
    5.	Latte separator
    6.	Vassoio di sistema
    7.	Orologio digitale
    8.	Latte separator
    9.	Centro notifiche

- **Blocco e spegnimento**: pannello fluttuante (allineato a sinistra) composto da:
    1.	Applet blocca-esci
    2.	Applet Menu globale

- **Script di Kwin**
    1. **Panel auto hide**: aggiunge la funzionalità “dodge” per i pannelli di KDE. Quando si passa con una finestra molto vicino ad un pannello, quest’ultimo viene nascosto.

- **Effetti del desktop**
    1. **Lampada magica**: quando una finestra viene minimizzata avviene un'animazione simile a quella di MacOS.

### Layout "Pseudo tiling"
Emula (così così) la gestione delle finestre di un tiling WM su KDE.

![image](https://github.com/lu-papagni/dots/assets/89859659/78497964-215c-40c4-bab6-13438512193c)

#### Associazioni tasti
| Funzione                            | Shortcut                     |
|-------------------------------------|------------------------------|
|     Modificatore                    |     Super (tasto Windows)    |
|     Esegui sopra                    |     K                        |
|     Esegui sotto                    |     J                        |
|     Esegui a destra                 |     L                        |
|     Esegui a sinistra               |     H                        |
|     Cambia dimensione               |     Ctrl                     |
|     Scambia                         |     Shift                    |
|     Sposta (*)                      |     Alt                      |
|     Riaggancia tutte le finestre    |     Mod+Shift+Spazio         |

(*) La funzione ´sposta´ modifica la posizione nel layout come ´scambia´ ma a differenza di quest'ultima non esegue uno swap ma muove fisicamente la finestra nella nuova posizione cambiando la dimensione a tutte le altre.

I tasti possono essere **combinati** a piacimento per eseguire tutte le operazioni. Ad esempio, per prendere il focus sulla finestra a destra bisognerà premere `Mod+L`; per estendere una finestra verso il basso `Mod+Ctrl+J` e così via.
Per spostare una finestra liberamente basta tenere premuto Mod e trascinare con il mouse da un punto qualsiasi.

- **System tray**
    1. 	Come nell'esempio precedente ma senza il _cambia-desktop_.

- **Blocco e spegnimento**
    1.  Applet _blocca-esci_
    2.	Latte separator
    3.	Applet _window title_

- **Desktop virtuali**
    1. 	Pannello fluttuante (allineato al centro) composto da un solo elemento, cioè il _cambia-desktop_.

- **Script di KWin**
    1. 	Polonium: fornisce il backend per emulare un tiling window manager.
    2.	Finestre tremolanti: quando una finestra viene spostata e/o ridimensionata si muove come se fosse fatta di gelatina.
    3.	Geometry Change: interpola le modifiche grafiche (dimensione, posizione) delle finestre da parte degli script. Serve per avere animazioni fluide con Polonium.
    4.	ShapeCorners: applica angoli e bordi tondi alle finestre di KWin. Deve essere compilato da [codice sorgente](https://github.com/matinlotfali/KDE-Rounded-Corners).

- **Tema**
    1. Stile di plasma: BreezeOutline
    2. Decorazioni delle finestre: Breeze
        -	Rimuovere la barra del titolo
        -	Impostare i bordi a ´sottile´

![image](https://github.com/lu-papagni/dots/assets/89859659/e731993c-61d9-4c53-9b10-479ed0be53c1)


## Hyprland
Uno tra i tiling WM più innovativi basato su Wayland, il nuovo protocollo grafico standard di Linux. Supporta le animazioni delle finestre ed effetti come la sfocatura.
Poiché Hyprland è un progetto molto sperimentale, al momento si trova solo in [questa copr](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/) su Fedora (_aggiornato al 08/01/2024_).

### Componenti
- **Barra di stato**: waybar
- **Gestore delle notifiche**: swaync (disponibile nelle [copr](https://copr.fedorainfracloud.org/coprs/erikreider/SwayNotificationCenter/))
- **Blocco schermo**: swaylock-effects (disponibile nelle [copr](https://copr.fedorainfracloud.org/coprs/eddsalkield/swaylock-effects/))
- **Menu di logout**: wlogout
