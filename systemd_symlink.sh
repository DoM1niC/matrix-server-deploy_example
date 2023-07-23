bash /opt/matrix/cli.sh disable
ln -sf /opt/matrix/systemd/*.service /etc/systemd/system/
ln -sf /opt/matrix/systemd/appservices/*.service /etc/systemd/system/
ln -sf /opt/matrix/systemd/services/*.service /etc/systemd/system/
systemctl daemon-reload
bash /opt/matrix/cli.sh enable
