Dieses Deployment dient als Beispiel und entspricht meiner privaten Synapse Instanz.

*Ich hafte nicht für Schäden oder Probleme die durch das verwenden auftreten, Änderungen sollten bedacht durchgeführt werden.*

# Aufbau / Struktur
meine Matrix Instanz läuft mit Linux (Arch), daher wird in diesem Deployment Systemd verwendet, um Dienste zu verwalten.

**Pfad:** `/opt/matrix` wird meiner Umgebung verwendet und muss jeweilig angepasst werden.

Die `cli.sh` kann mit gängigen Systemd Aktionen angesprochen werden z.B. `start / stop / restart` usw.

Die `systemd_setup.sh` kopiert euch die gängigen Service Dateien in eure **Systemd**, dies kann via dem `systemd` Ordner angepasst werden.

Die `update.sh` kann verschiedene Appservices oder Synapse updaten z.B. `update.sh synapse`

## Ordner
- **data** (statische Dateien wie Medien)
- **services** (weitere Dienste für Matrix, außerhalb von Synapse)
- **systemd** (Systemd Service Dateien)
- **conf** (Konfigurationen)
- **nginx** (Konfigurationen für NGINX)
- **www** (Clients Element usw.)
- **appservices** (Appservices z.B. Bridges)

In dem Ordner namens `buildung` findet ihr eine `build.sh` damit könnt ihr das gesamte Matrix Ökosystem selbst zusammenbauen (kompilieren).

# NGINX
Verlinkung in den `vhosts` durch z.B. Symlink erforderlich siehe `nginx` Ordner.
- matrix.conf
- call.conf

`server_name` usw. muss angepasst werden, bis den Ordner `workers`.
