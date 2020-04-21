#!/bin/bash

DEPLOYMENT=""
DIR_PATH=""
INSTANCE=""

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--deployment=)
    DEPLOYMENT="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--path=)
    DIR_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--instance=)
    INSTANCE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z "$DEPLOYMENT" ]; then
        echo "--- Backing up nats certs from all deployments ---"
else
        echo "--- Backing up nats certs for deployment: $DEPLOYMENT ---"
fi

if [ -z "$DIR_PATH" ]; then
        DIR_PATH="/tmp/vms"
fi

echo "--- Backing up to folder $DIR_PATH ---"

mkdir $DIR_PATH
bosh -d $DEPLOYMENT ssh -c "sudo cp /var/vcap/bosh/settings.json /tmp/settings.json"
bosh -d $DEPLOYMENT scp $INSTANCE:/tmp/settings.json "$DIR_PATH/((instance_id))"
