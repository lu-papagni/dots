# Firewall
Nella distribuzione potrebbe essere installato `firewalld`.
Per impostazione predefinita il software blocca tutti i tipi di pacchetto sulla rete. Questo potrebbe creare problemi specialmente
durante le operazioni di stampa e accesso a dichi di rete.
- **Servizio di stampa** ➡️ attivare `ipp-client`
- **Condivisione file con SAMBA** ➡️ attivare `samba-client`

Firewalld permette di definire delle "zone" in cui attivare specifiche regole.
È consigliabile utilizzare la zona _home_ per abilitare le regole elencate in precedenza.
Infine è necessario aggiungere la rete desiderata alla zona _home_ per rendere effettive le modifiche.

# Discord
Discord non rileva di default la presenza dei _desktop portals_, necessari per condividere lo schermo.
Per correggere il problema basta eseguire il programma esportando la variabile d'ambiente `XDG_SESSION_TYPE=x11`.

