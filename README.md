# Installazione

## Fedora

- Scaricare la versione [Everything](https://alt.fedoraproject.org).
- Alla richiesta di creare un utente root scegliere **NO**.

[Problemi e fix](https://github.com/lu-papagni/dots/blob/main/DOCS/FEDORA_ISSUES.md)

## Arch-based

- [Arch Linux](https://archlinux.org/download/) usando lo script `archinstall`
- [CachyOS](https://cachyos.org/download/) (consigliato)

[Problemi e fix](https://github.com/lu-papagni/dots/blob/main/DOCS/ARCH_ISSUES.md)

# Configurazione

## Dotfiles

Usare l'apposito [script](https://github.com/lu-papagni/dots/blob/main/init.sh).

### Utilizzo

Pre-requisiti:
- `curl`
- `git`

> [!WARNING]
> È necessaria una shell compatibile *POSIX*.

Sintassi:

```
init.sh [parametri...]

```

Lo script accetta i seguenti parametri posizionali:
1. `DOTS_DIR` -> Determina la directory dove verrà clonata la repo.

```sh
curl -sL https://raw.githubusercontent.com/lu-papagni/dots/main/init.sh | sh -s -- ~/.dotfiles
```

# Extra

- Risoluzione problemi di altre [utility e programmi](https://github.com/lu-papagni/dots/blob/main/DOCS/UTILITIES.md)
- Configurazione del filesystem [BTRFS](https://github.com/lu-papagni/dots/blob/main/DOCS/BTRFS.md)
- Breve guida ai [gestori delle finestre](https://github.com/lu-papagni/dots/blob/main/DOCS/WINDOW_MANAGERS.md)
