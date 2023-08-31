Synapse arbeitet im Normalbetrieb nur mit einem Thread, daher bietet es eine Option verschiedene Aufgaben mit Worker zu skalieren, jeder Worker besitzt einen eigenen Port in 
Kombination mit z.B. NGINX lässt jeder Endpunkt zusammenbauen durch einen `proxy_pass`.

Hier erstelle eine einfache Variante wie Worker z.B. in meiner Umgebung verwendet werden.

# Aufbau 
Jeder Worker besitzt eine eigene Config (`conf/worker`) mit einem Port, dieser wird mit dem Worker gestartet.

Es gibt allgemeine und spezielle (generic) Worker, die verschiedene Aufgaben handeln können.

Welche Worker, wie genutzt werden können findet man auch in der offiziellen Doku https://github.com/matrix-org/synapse/blob/develop/docs/workers.md

In diesem Beispiel finden wir die Enpunkte für die Worker unter `nginx/worker`.

# Systemd
Die Worker können mit einer passenden Systemd Service Datei dynamisch (generic) gestaret werden, Außnahme Media Worker.

#### folgende Service Dateien werden zum starten verwendet...
- matrix_main.service (Synapse)
- matrix_generic_worker@.service (generic Worker)
- matrix_media.service (Media Worker)

Dienste siehe `cli.sh` können mit `start / restart / enable` (autostart) gestartet werden.

## Beispiel aus meiner Umgebung 
### Main (Synapse)
- matrix_main.service
### Medien Endpunkte
- matrix_media.service
### Client Endpunkte
- matrix_generic_worker@client.service
- matrix_generic_worker@federation_reader.service
- matrix_generic_worker@synchrotron.service
- matrix_generic_worker@events.service
- matrix_generic_worker@user_dir.service
- matrix_generic_worker@appservice.service
- matrix_generic_worker@background.service
- matrix_generic_worker@frontend_proxy.service
- matrix_generic_worker@pusher.service
- matrix_generic_worker@federation_sender.service

# Beispielaufbau einer Systemd
```
[Unit]
Description=Matrix Synapse Workers
After=matrix_main.service

[Service]
User=root
Group=root
WorkingDirectory=/opt/matrix
ExecStart=/opt/matrix/bin/python -m synapse.app.generic_worker --config-path=conf/config.yaml --config-path=conf/conf.d/ --config-path=conf/workers/%i.yaml
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target
```


