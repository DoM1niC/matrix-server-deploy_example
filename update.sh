#!/bin/bash

MATRIX_PATH=/opt/matrix
MATRIX_VERSION=`cat $MATRIX_PATH/version`
NODEJS_VERSION=16.19.0
NPM=/root/.nvm/versions/node/v$NODEJS_VERSION/bin/npm

case $2 in
  install)
    clean="rm -rf python/ lib/ lib64 bin/ local/"
    install="python -m venv ."
    ;;
  *)
    clean=""
    install=""
    ;;
esac

case $1 in
  deploy)
    echo Update Server Deploy
    cd $MATRIX_PATH
    chmod 777 -R $MATRIX_PATH/.git/
    git fetch origin
    git reset --hard origin/main
    chmod 777 *.sh -R
    cd $MATRIX_PATH/www/about
    git reset --hard origin/master
    git pull origin master
    systemctl reload nginx.service
    chmod 777 $MATRIX_PATH/services/ -R
    systemctl restart matrix_livekit.service
    systemctl restart matrix_livekit_auth.service
    #systemctl restart matrix_syncv3.service
    ;;

  synapse)
    echo Update Matrix Synapse
    cd $MATRIX_PATH
    $clean; \
    $install; \
    source bin/activate; \
    pip install --upgrade pip; \
    pip install --upgrade setuptools; \
    pip install --upgrade matrix-synapse; \
    pip install --upgrade git+https://git.3dns.eu/3DNS/matrix-synapse-rest-password-provider; \
    pip install --upgrade matrix-http-rendezvous-synapse; \
    pip install --upgrade matrix-synapse[oidc]; \
    pip install --upgrade Jinja2; \
    pip install --upgrade psycopg2-binary; \
    pip install --upgrade hiredis; \
    pip install --upgrade 'lxml>=3.5.0'; \
    pip install --upgrade txredisapi; \
    pip install --upgrade treq; \
    pip install --upgrade twisted

    echo restart Services
    /opt/matrix/cli.sh restart
    ;;

  sydent)
    echo "Update Identify Service Sydent"
    cd $MATRIX_PATH/services/sydent/
    $clean; $install
    source bin/activate;
    pip install --upgrade matrix-sydent
    systemctl restart matrix_identity.service
    ;;

  sygnal)
    echo "Update Sygnal Push Gateway"
    cd $MATRIX_PATH/services/sygnal/
    $clean; $install; \
    source $MATRIX_PATH/services/sygnal/bin/activate; \
    pip install --upgrade pip; \
    pip install --upgrade setuptools; \
    pip install --upgrade opentracing; \
    pip install --upgrade ./ --use-pep517
    systemctl restart matrix_sygnal.service
    ;;

  webhooks)
    echo Update Webhook Appservice
    cd $MATRIX_PATH/appservices/webhooks
    rm -rf node_modules
    sudo -u matrix git fetch; git reset --hard origin/master; /usr/bin/npm install sqlite3; /usr/bin/npm install db-migrate-sqlite3 --unsafe-perm=true --allow-root; /usr/bin/npm install
    systemctl restart matrix_webhooks.service
    ;;

  bot)
    echo Update Bot
    cd $MATRIX_PATH/bots/own
    $clean; $install; \
    source bin/activate; \
    pip install --upgrade pip; \
    pip install --upgrade setuptools; \
    pip install --upgrade requests; \
    pip install --upgrade pythonping; \
    pip install --upgrade https://git.3dns.eu/Matrix/simplematrixbotlib/archive/master.tar.gz
    systemctl restart matrix_bot.service
    ;;

  maubot)
    echo Update Mautrix Maubot
    cd $MATRIX_PATH/bots/maubot
    $clean; $install; \
    source bin/activate; \
    pip install --upgrade pip; \
    pip install --upgrade setuptools; \
    pip install --upgrade feedparser; \
    pip install --upgrade psycopg2-binary; \
    cd $MATRIX_PATH/bots/maubot/src/; git pull origin master; pip install --upgrade .
    cd $MATRIX_PATH/bots/maubot/src/maubot/management/frontend; yarn; yarn build
    systemctl restart matrix_maubot.service
    ;;

  whatsapp)
    echo Update WhatsApp Appservice
    cd $MATRIX_PATH/appservices/whatsapp/
    git fetch origin
    git reset --hard origin/master
    go clean
    go get
    go build
    systemctl restart matrix_whatsapp.service
    ;;

  skype)
    echo Update Skype Appservice
    cd $MATRIX_PATH/appservices/skype/
    git fetch origin
    git reset --hard origin/master
    ./build.sh
    systemctl restart matrix_skype restart
    ;;

  discord)
    echo Update Discord Appservice
    cd $MATRIX_PATH/appservices/discord/
    git fetch origin
    git reset --hard origin/main
    go clean
    go get
    go build
    systemctl restart matrix_discord.service
    ;;

  facebook)
    echo Update Facebook Appservice
    cd $MATRIX_PATH/appservices/facebook/
    $clean; $install; source bin/activate; pip install --upgrade pip; pip install --upgrade setuptools; pip install --upgrade ffmpeg; pip install --upgrade https://github.com/mautrix/facebook/tarball/master#egg=mautrix-facebook[all]
    systemctl restart matrix_facebook.service
    ;;

  telegram)
    echo Update Telegram Appservice
    cd $MATRIX_PATH/appservices/telegram/
    $clean; $install; source bin/activate; pip install --upgrade pip; pip install --upgrade setuptools; pip install --upgrade ffmpeg; pip install --upgrade https://github.com/mautrix/telegram/tarball/master#egg=mautrix-telegram[all]
    systemctl restart matrix_telegram.service
    ;;

  instagram)
    echo Update Instagram Appservice
    cd $MATRIX_PATH/appservices/instagram/
    $clean; $install; source bin/activate; pip install --upgrade pip; pip install --upgrade setuptools; pip install --upgrade ffmpeg; pip install --upgrade https://github.com/mautrix/instagram/tarball/master#egg=mautrix-instagram[all]
    systemctl restart matrix_instagram.service
    ;;

  irc)
    echo Update IRC Appservice
    cd $MATRIX_PATH/appservices/irc/
    rm -rf node_modules
    git fetch origin; git reset --hard origin/develop; /root/.nvm/versions/node/v18.16.0/bin/npm install; /root/.nvm/versions/node/v18.16.0/bin/npm run build
    systemctl restart matrix_irc.service
    ;;

  steam)
    echo Update Steam Appservice
    cd $MATRIX_PATH/appservices/steam/
    nvm use v12.22.12
    rm -rf node_modules; git fetch origin; git reset --hard origin/master; /root/.nvm/versions/node/v12.22.12/bin/npm install; /root/.nvm/versions/node/v12.22.12/bin/npm run build
    systemctl restart matrix_steam.service
    ;;

  signal)
    echo Update Signal Appservice
    cd $MATRIX_PATH/appservices/signal/
    $clean; $install
    source bin/activate; pip install --upgrade pip; pip install --upgrade setuptools; pip install --upgrade ffmpeg; pip install --upgrade https://github.com/mautrix/signal/tarball/master#egg=mautrix-signal[all]
    systemctl restart matrix_signal.service
    ;;

  linkedin)
    echo "Update linkedin Appservice"
    cd $MATRIX_PATH/appservices/linkedin/
    $clean; $install
    source bin/activate; pip install --upgrade setuptools; pip install --upgrade linkedin-matrix
    systemctl restart matrix_linkedin.service
    ;;

  chatgpt)
    echo Update ChatGPT Bot
    cd $MATRIX_PATH/bots/chatgpt/
    rm -rf node_modules
    git fetch origin; git reset --hard origin/main; yarn install; yarn build
    systemctl restart matrix_chatgpt.service
    ;;

  *)
    echo "Command is missing"
    ;;
esac