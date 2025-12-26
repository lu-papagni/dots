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

