# Snapshot BTRFS
Se il sistema è stato configurato con il filesystem BTRFS, è possibile configurare la funzione degli snapshot del disco.
Attivandola, il sistema potrà essere all'occorrenza riportato ad uno stato funzionante nel caso in cui dovesse avvenire un malfunzionamento,
come un aggiornamento che introduce un bug critico o corruzione dei dati.
Usare come riferimento i seguenti articoli:
1. [BTRFS snapshots and system rollbacks on Arch Linux - Daniel Wayne Armstrong](https://www.dwarmstrong.org/btrfs-snapshots-rollbacks/)
2. [EndeavourOS System Recovery - pavinjosdev](https://github.com/pavinjosdev/eos-system-recovery)

## Pre-requisiti
Avere installati i seguenti pacchetti:
- `snapper` ➡️ esegue gli snapshot
- `snap-pac` (opzionale) ➡️ hook di pacman che fa uno snapshot ogni volta che avviene un'installazione
- `grub-btrfs` ➡️ permette di accedere agli snapshot da grub
- `inotify-tools` ➡️ dipendenza di _grub-btrfs_

## Configurazione
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
Ora bisogna creare un nuovo sotto-volume btrfs per contenere gli snapshot. Snapper ha creato di default la directory `/.snapshots`,
ma non l'ha separata dal contenuto della root. In questo modo, se mai servisse effettuare un rollback,
si andrebbero a perdere tutti gli snapshot fatti _dopo_ quello ripristinato.

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
Al posto di `<xxx-xxx-xxx-xxx-xxx>` bisogna inserire l'ID comune alle altre partizioni btrfs presenti;
le opzioni di montaggio possono essere copiate da quelle già usate dalle altre partizioni.

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

A questo punto è necessario configurare una modalità per accedere agli snapshot.
Una soluzione è quella di usare una funzione chiamata _overlayfs_, la quale permette di avviare uno snapshot come se fosse un CD live.
In questo modo avremo accesso alla GUI, da cui potremo effettuare la manutenzione.

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

13. Aggiungere `/.snapshots` alle eccezioni durante l'indicizzazione del disco. Modificare `/etc/updatedb.conf`,
    aggiungendo la stringa `.snapshots` alla variabile `PRUNENAMES`.
14. Per effettuare la manutenzione, fare riferimento al paragrafo 11 dell'articolo 1 mostrato in precedenza.
