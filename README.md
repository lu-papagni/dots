# Set-up Linux

## Installazione
### Fedora
- La [versione](https://alt.fedoraproject.org) da installare è _Fedora Everything_.
- Se l’installazione non dovesse partire, provare ad avviare l’immagine ISO in modalità grafica ridotta.
- Alla richiesta di creare un utente root scegliere **NO**.

### Arch
Non ho ancora trovato la voglia.

## Configurazione
### Dotfiles
La maggior parte delle impostazioni dei software su Linux è salvata nei loro rispettivi file di configurazione (in gergo _dotfiles_).
Questi ultimi sono salvati in [questa repository](https://github.com/lu-papagni/dots). Per gestire i _dotfiles_ più facilmente ho creato un alias basato su git per sincronizzarli.

Per utilizzarlo è necessaria una **shell compatibile POSIX** (come bash, zsh…) e seguire questo procedimento:
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

### Plugin per la shell
La shell _zsh_ è compatibile con molte estensioni di terze parti. Per essere sicuri che rimangano sempre aggiornate, può essere utile installare [Oh-My-Zsh](https://ohmyz.sh), un popolare plugin manager.
- Installazione di _Oh-My-Zsh_:
  
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

Queste sono delle estensioni utili:
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k#for-new-users) (prompt compatibile con zsh)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) completa i comandi che si scrivono al terminale
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) evidenzia il ruolo delle parole che si scrivono 

## Gestore delle finestre
Su Linux si può scegliere l'ambiente grafico in modo molto libero. La prima decisione è sul tipo di gestore delle finestre (_window manager_ o _WM_ in breve) da usare, ovvero il software che posiziona
le finestre sullo schermo. In generale si dividono in due categorie: _stacking_ e _tiling_.

Come si comportano le finestre in queste due varianti?
- **Stacking**
    - si riaprono nell'ultimo posto dove sono state chiuse
    - possono sovrapporsi
    - hanno una barra del titolo con cui si possono spostare, minimizzare, ingrandire e chiudere.
- **Tiling**
    - sono gestite secondo un layout predefinito
    - vengono disegnate a partire da un punto specifico (uno degli angoli dello schermo o in corrispondenza della finestra attiva).
    - Le finestre solitamentee non si sovrappongono mai. Esistono dei a meno che non vengano spostate manualmente (quindi sganciate dal layout).
    - Per cambiare la finestra attiva, spostarla in un altro punto, ridimensionarla, chiuderla, ecc. si usano degli shortcut formati solitamente da un modificatore e altri tasti.

Generalmente, i WM stacking sono quelli più comuni e semplici da configurare. In più, portano con sé molti programmi pre-installati. Per dare un'idea, anche Windows ne usa uno di questo tipo.

I gestori tiling, invece, hanno meno funzionalità dell'altro tipo e sono più complicati da gestire. Sono davvero utili per chi lavora molto con il terminale e si trova ad avere spesso la necessità di
aprire/allineare più istanze per avere tutto sotto controllo. O per flexare 🗿.

| ![](https://www.html.it/app/uploads/2022/03/kde.png "Stacking window manager KDE") |
|:--:|
| *KDE, stacking* |
| ![](https://storage.googleapis.com/zenn-user-upload/38ff1f02ef60253135f77e14.png "Tiling window manager Sway") |
| *Sway, tiling* |
