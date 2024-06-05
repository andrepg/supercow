#!/bin/bash

echo "Downloading Discord files"

cd $HOME/Downloads
wget -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"

echo "Extracting directly to .var/app"
tar --overwrite -xvzf discord.tar.gz -C $HOME/.var/app/

PATH_DISCORD="$HOME/.var/app/Discord"
$FLAGS="--enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto"

echo "Changing variables to Desktop file"
sed -i "s%Exec=\/usr\/share\/discord\/Discord%Exec=$PATH_DISCORD\/Discord $FLAGS%g" $PATH_DISCORD/discord.desktop
sed -i "s%Path=\/usr\/bin%Path=$PATH_DISCORD%g" $PATH_DISCORD/discord.desktop
sed -i "s%Icon=discord%Icon=$PATH_DISCORD\/discord.png%g" $PATH_DISCORD/discord.desktop

echo "Publish desktop file changes"
cp -r $HOME/.var/app/Discord/discord.desktop $HOME/.local/share/applications

rm -r discord.tar.gz
