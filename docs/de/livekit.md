# Livekit Installation
## Benötigt
- GO
- Redis Server
- NGINX Webserver
## Ports
UDP: 50100 - 50200

TCP: 7880 / 8080 (nur localhost)
## Download
Neuste Livekit Version: https://github.com/livekit/livekit/releases

## Installation
Inhalt der livekit_1.x.x_linux_amd64.tar.gz in `services/livekit` entpacken & `config.yaml` anpassen, darunter Zeile **prod** mit einem eigenen Key anpassen.
```
keys:
  prod: "**************************************"
```
## JWT Service bauen
Der JWT Service vergibt für den Livekit Server passenden OpenIDs, sprich dieser kleine Service authentifiziert das Matrix Ökosystem mit dem Livekit Server. Die Verbindungen zum eigentlichen Livekit Server, werden von diesem Services weitergeleitet z.B. an `sfu.domain.tld` siehe **Systemd** Teil.

`git clone https://github.com/vector-im/lk-jwt-service livekit-jwt-service` klonen und `buildung/build.sh livekit-jwt-service` ausführen um den JWT Service (Dockerless) zu bauen.
die erstelle Binary `lk-jwt-service` unter `services/livekit` einfügen. 

Der Dienst läuft dann unter `127.0.0.1:8080`, bekommt dann mit der NGINX Config einen **proxy_pass** zugewiesen für eine Subdomain z.B. sfu-jwt.domain.tld.

## NGINX
unter `nginx/call.conf` müssen die Subdomains angepasst werden, in meinem Beispiel verwende ich für Livekit das Prefix `sfu.`, die `call.conf` muss in **VHosts** kopiert werden, damit NGINX diese auch lädt.
## Element Call
config.json anpassen.
```
"livekit": {
  "livekit_service_url": "https://sfu-jwt.domain.tld"
  },
```
## Dienste starten (Systemd)
Services für Systemd unter `systemd/services/matrix_livekit.service` & `matrix_livekit_auth.service` in `/etc/lib/systemd/system` kopieren.
### matrix_livekit_auth.service anpassen (Key & Subdomain).
```
Environment="LIVEKIT_URL=wss://sfu.domain.tld"
Environment="LIVEKIT_KEY=prod"
Environment="LIVEKIT_SECRET=*********************"
```

`systemctl enable matrix_livekit.service --now` &  `systemctl enable matrix_livekit_auth.service --now` Dienst starten inkl. Autostart

