#!/bin/bash

echo "Downloading VSCode from source"
echo ""
wget -O vscode-latest.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"

echo ""
echo ""
echo "Unpacking VSCode on current path"
echo ""
tar -zxf vscode-latest.tar.gz

VSCODE_PATH="$HOME/.var/app/vscode"
echo ""
echo ""
echo "Copying VSCode to $VSCODE_PATH"
echo ""
mkdir -p $VSCODE_PATH
cp -vR VSCode-linux-x64/* $VSCODE_PATH

echo "Updating Desktop Icon"
FLAGS="--enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto --unity-launch %F"

touch vscode.desktop
echo "[Desktop Entry]" >> vscode.desktop
echo "Name=Visual Studio Code" >> vscode.desktop
echo "StartupWMClass=code-url-handler" >> vscode.desktop
echo "Icon=$VSCODE_PATH/resources/app/resources/linux/code.png" >> vscode.desktop
echo "Type=Application" >> vscode.desktop
echo "Categories=Development;" >> vscode.desktop
echo "Path=$VSCODE_PATH" >> vscode.desktop
echo "Keywords=vscode;code;visual;studio;" >> vscode.desktop
echo "MimeType=x-scheme-handler/vscode" >> vscode.desktop
echo "Exec=$VSCODE_PATH/code $FLAGS" >> vscode.desktop

cp -r vscode.desktop $HOME/.local/share/applications/vscode.desktop

echo ""
echo "Cleaning garbage left behind"
echo ""
rm -r VSCode-linux-x64
rm -r vscode-latest.tar.gz
rm -r vscode.desktop
