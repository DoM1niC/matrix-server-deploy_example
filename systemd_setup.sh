bash /opt/matrix/cli.sh disable
cp -r /opt/matrix/systemd/*.service /usr/lib/systemd/system
cp -r /opt/matrix/systemd/appservices/*.service /usr/lib/systemd/system
cp -r /opt/matrix/systemd/services/*.service /usr/lib/systemd/system
systemctl daemon-reload
bash /opt/matrix/cli.sh enable
