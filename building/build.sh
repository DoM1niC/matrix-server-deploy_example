#!/bin/bash
DEPLOY_PATH="/opt/matrix"

case $1 in

  clone)
    git clone https://github.com/matrix-org/sliding-sync matrix-syncv3
    git clone https://github.com/matrix-org/synapse matrix-synapse
    git clone https://github.com/matrix-org/matrix-react-sdk matrix-react-sdk
    git clone https://github.com/matrix-org/matrix-js-sdk matrix-js-sdk
    git clone https://github.com/vector-im/element-web matrix-web
    git clone https://github.com/vector-im/element-call matrix-call
    git clone https://github.com/vector-im/lk-jwt-service livekit-jwt-service
    ;;

  web)
    pushd matrix-js-sdk
    git reset --hard origin/develop
    yarn link
    yarn install
    popd

    pushd matrix-react-sdk
    yarn link
    yarn link matrix-js-sdk
    yarn install
    popd

    cd matrix-web
    yarn link matrix-js-sdk
    yarn link matrix-react-sdk
    yarn install
   
    case $2 in
      dev)
        yarn start
        ;;
      *)
        yarn build
        echo "Build success"
        ;;
      esac
    ;;

  call)
    pushd matrix-js-sdk
    git fetch orig
    git reset --hard orig/develop
    yarn link
    yarn install
    popd

    cd matrix-call
    yarn link matrix-js-sdk
    yarn install

    case $2 in
      dev)
        yarn start
        ;;
      *)
        yarn build
        cp config/config.sample.json dist/config.json
        echo "Build success"
        ;;
      esac
    ;;
    
    syncv3)
      cd matrix-syncv3
      git fetch origin
      git reset --hard origin/main
      go get
      go build ./cmd/syncv3
      cp syncv3 $DEPLOY_PATH/services/syncv3
      echo "Build success"
      ;;

    livekit-jwt-service)
      cd livekit-jwt-service
      git fetch origin
      git reset --hard origin/main
      go mod download
      go build -o lk-jwt-service
      cp lk-jwt-service $DEPLOY_PATH/services/livekit
      echo "Build success"
      ;;

    synapse)
      cd matrix-synapse
      git fetch origin
      git reset --hard $2
      python3 -m venv ./
      source bin/activate
      pip wheel .
      mv matrix_synapse-* $DEPLOY_PATH
      echo "Build success"
      ;;

  *)
    echo -e "\nYou can use following commands for building:\n\nclone\nweb\ncall\nsyncv3\nlivekit-jwt-service\nsynapse"
    echo -e "\nYou can use a second parameter called \"dev\" for web / call like ./build.sh web dev and for Synapse, you have to use the Tag or Branch like ./build.sh synapse master"
    ;;
esac