#!/bin/bash

# GET version variable to download
[[ -z "$1" ]] && { echo "Error: Version not specified"; exit 1; }

DOL_URL=https://github.com/Dolibarr/dolibarr/archive/refs/tags/$1.zip
PUBLIC_PATH="/home/startap/web/manager.startap.dev.br/public_html/"

echo ">> Downloading Dolibarr version $1"
wget --show-progress $DOL_URL

echo ">> Unzipping dolibarr files"
unzip -q $1.zip
cd dolibarr-$1/htdocs

echo "Syncing files with Dolibarr instance"
rsync --human-readable -azuP ./* $PUBLIC_PATH

# You should change this to fit webserver user, otherwise can encounter some filesystem issues 
# chown USER:GROUP -R $PUBLIC_PATH

echo "Cleaning our mess after downloading and unziping files"
cd ../../
rm -r dolibarr-$1 $1.zip
