# Configurazione di Fedora
## Installazione
- La [versione](https://alt.fedoraproject.org) da installare è _Fedora Everything_.
- Se l’installazione non dovesse partire, provare ad avviare l’immagine ISO in modalità grafica ridotta.
- Alla richiesta di creare un utente root scegliere **NO**.

## Configurazione
### Dotfiles
La maggior parte delle impostazioni dei software su Linux è salvata nei loro rispettivi file di configurazione (in gergo _dotfiles_).
Questi ultimi sono salvati in [questa repository](https://github.com/lu-papagni/dots). Per gestire i _dotfiles_ più facilmente ho creato un alias basato su git per sincronizzarli.

Per utilizzarlo è necessaria una **shell compatibile POSIX** (come bash, zsh…) e seguire questo procedimento:
1.  Creare una directory _dummy_ (ovvero non utilizzata da noi ma solo come bersaglio del comando). Io l'ho posizionata in `~/.dotfiles`;
2.	Spostarsi in quest'ultima directory ed inizializzare un progetto vuoto con git: `git init --bare`
3.	Definire il seguente alias all'interno del file di configurazione della propria shell. Da notare che la directory git specificata è proprio quella creata in precedenza.
    - `alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"`
5.  Per questa directory conviene disattivare l’impostazione secondo cui git mostra in automatico i file non selezionati per il monitoraggio. Normalmente è una funzione utile,
    ma in questo caso il software ci consiglierebbe ogni volta di aggiungere file non pertinenti al progetto (probabilmente l'intera directory `/home`).
    - `dotfiles config --local status.showUntrackedFiles no`
6.  Una volta fatto ciò sarà possibile gestire i dotfiles come se fossero un normale progetto git. L’unica differenza è nel push dei file: bisognerà infatti specificare repository
    e branch ogni volta che si vuole eseguire un backup. Ad esempio: `dotfiles push --set-upstream https://github.com/lu-papagni/dots.git main`. In alternativa si potrebbero configurare
    le proprietà del ramo locale per puntare alla nostra repository per evitare di ripetere l'indirizzo ogni volta.

### Plugin per la shell
La shell _zsh_ è compatibile con molte estensioni di terze parti. Per essere sicuri che rimangano sempre aggiornate, può essere utile installare [Oh-My-Zsh](https://ohmyz.sh), un popolare plugin manager.
- Installazione di _Oh-My-Zsh_: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

Queste sono delle estensioni utili:
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k#for-new-users) (prompt compatibile con zsh): `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) completa i comandi che si scrivono al terminale
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) evidenzia il ruolo delle parole che si scrivono 
