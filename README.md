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
Le migliori opzioni sono [Arch Linux](https://archlinux.org/download/) usando lo script `archinstall` o [EndeavourOS](https://endeavouros.com/#Download).
Quest'ultima distribuzione ha un installer più _user-friendly_ e permette di scegliere fra una grande selezione di _desktop environment_ attraverso l'installazione online. In modalità offline è presente solo KDE.

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
La maggior parte delle impostazioni dei software su Linux è salvata nei loro rispettivi file di configurazione (in gergo _dotfiles_).
Questi ultimi sono salvati in [questa repository](https://github.com/lu-papagni/dots). Per gestire i _dotfiles_ più facilmente ho creato un alias basato su git per sincronizzarli.

Per utilizzarlo è necessaria una **shell compatibile POSIX** (come bash, zsh…) e seguire questo procedimento:

> [!IMPORTANT]
> Questo processo era un po' troppo macchinoso, quindi ora lo script prevede che si debba semplicemente clonare la repository in `~/.config` (senza sotto-directory). In questo modo si
> può gestire il tutto con gli stessi comandi di qualsiasi altra repo. Per i file che hanno bisogno di risiedere direttamente in `/home`, lo script creerà dei link simbolici.
>
> Il *punto 4* è ancora molto consigliato (ovviamente non usando l'alias ma questo comando in `.config`):
>
> ```bash
> git config --local status.showUntrackedFiles no
> ```

1.  Creare una directory _dummy_ (ovvero non utilizzata da noi ma solo come bersaglio del comando). Io l'ho posizionata in `~/.dotfiles`;
2.	Spostarsi in quest'ultima directory ed inizializzare un progetto vuoto con git.

    ```bash
  	git init --bare
    ```

4.	Definire il seguente alias all'interno del file di configurazione della propria shell. Da notare che la directory git specificata è proprio quella creata in precedenza.

    ```bash
  	alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
    ```
    
6.  Per questa directory conviene disattivare l’impostazione secondo cui git mostra in automatico i file non selezionati per il monitoraggio. Normalmente è una funzione utile,
    ma in questo caso il software ci consiglierebbe ogni volta di aggiungere file non pertinenti al progetto (probabilmente l'intera directory `/home`).
    
    ```bash
    dotfiles config --local status.showUntrackedFiles no
    ```
    
7.  Una volta fatto ciò sarà possibile gestire i dotfiles come se fossero un normale progetto git. L’unica differenza è nel push dei file: bisognerà infatti specificare repository
    e branch ogni volta che si vuole eseguire un backup. Ad esempio: `dotfiles push --set-upstream https://github.com/lu-papagni/dots.git main`. In alternativa si potrebbero configurare
    le proprietà del ramo locale per puntare alla nostra repository per evitare di ripetere l'indirizzo ogni volta.

## Plugin per la shell
La shell _zsh_ è compatibile con molte estensioni di terze parti. Per essere sicuri che rimangano sempre aggiornate, può essere utile installare [Oh-My-Zsh](https://ohmyz.sh), un popolare plugin manager.
- Installazione di _Oh-My-Zsh_:
  
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

Queste sono delle estensioni utili:
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k#for-new-users) (prompt compatibile con zsh)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) completa i comandi che si scrivono al terminale
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) evidenzia il ruolo delle parole che si scrivono

## Script di installazione
Ho creato uno script bash chiamato `kickstart.sh` per evitare i passaggi più ripetitivi, come installare i pacchetti e abilitare le repository di terze parti. Al momento è compatibile al 100% solo con Fedora e
[agg. _28/02/2024_] funziona abbastanza bene su Arch Linux (lo finirò prima o poi).
### Breve guida a kickstart
**Parametri opzionali**
- `-d` non modifica nulla sul sistema ma stampa l'output dei comandi che lo script avrebbe invece eseguito. Può essere utile per debug.
- `-l` mostra il log dei comandi che stanno venendo eseguiti.
- `-s` non controlla la presenza di eventuali dipendenze dello script (per debug).
- `-h` mostra una breve guida.

**Come si usa?**
1. Inserisci il nome del package manager (nel caso di Fedora è `dnf`)
2. Rispondi alle domande che appaiono
3. Spera che funzioni

**Attenzione!** Lo script esegue quasi tutti i comandi con privilegi di root, chiedendo solo la primissima volta la password.

## Firewall
Nella distribuzione potrebbe essere installato `firewalld`. Per impostazione predefinita il software blocca tutti i tipi di pacchetto sulla rete, e questo potrebbe creare problemi specialmente
durante le operazioni di stampa e accesso a dichi di rete.
- **Servizio di stampa** ➡️ attivare `ipp-client`
- **Condivisione file con SAMBA** ➡️ attivare `samba-client`

Firewalld permette di definire delle _zone_ in cui attivare specifiche regole. È consigliabile utilizzare la zona _home_ per abilitare le regole elencate in precedenza.
Infine è necessario aggiungere la rete desiderata alla zona _home_ per rendere effettive le modifiche.

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
