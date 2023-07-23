bash /opt/matrix/cli.sh disable
cp -r /opt/matrix/systemd/*.service /etc/systemd/system/
cp -r /opt/matrix/systemd/appservices/*.service /etc/systemd/system/
cp -r /opt/matrix/systemd/services/*.service /etc/systemd/system/
systemctl daemon-reload
bash /opt/matrix/cli.sh enable
