#!/bin/bash

# --- SETTINGS ---
DOWNLOAD_LINK="https://growtopiagame.com/Growtopia-Installer.exe"
INSTALLER_NAME="GrowtopiaSetup.exe"
WINE_DIR="$HOME/.growtopia-linux"
SHORTCUT_PATH="$HOME/Desktop/Growtopia.desktop"

clear
echo "==============================================="
echo "   growtopia linux installer v1.0              "
echo "==============================================="

# 1. SYSTEM CHECK
echo "[1/5] checking if u have wine and wget..."
dependencies=(wine wget winetricks)

for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "error: '$cmd' is not installed on your system."
        echo "please install it first: sudo apt install wine wget winetricks"
        exit 1
    fi
done
echo "ok: all tools found."

# 2. DOWNLOADING FILES
echo "[2/5] downloading the game setup file..."
if [ ! -f "$INSTALLER_NAME" ]; then
    wget -O "$INSTALLER_NAME" "$DOWNLOAD_LINK"
else
    echo "setup file already exists, skipping download."
fi

if [ $? -ne 0 ]; then
    echo "error: could not download file! check your internet."
    exit 1
fi

# 3. PREFIX SETUP
echo "[3/5] setting up wine folder ($WINE_DIR)..."
export WINEPREFIX="$WINE_DIR"
export WINEARCH=win32
winecfg /v win10 &> /dev/null

# 4. INSTALLING LIBRARIES
echo "[4/5] installing windows files (this takes a bit time)..."
winetricks -q vcredist2013 vcredist2015 d3dx9

echo "starting setup. please finish the windows installer steps..."
wine "$INSTALLER_NAME"

# 5. CREATING SHORTCUT
echo "[5/5] making desktop shortcut for u..."
GT_EXE_PATH=$(find "$WINE_DIR" -name "Growtopia.exe" | head -n 1)

if [ -z "$GT_EXE_PATH" ]; then
    echo "warning: growtopia.exe not found. did u finish the install?"
else
    cat <<EOF > "$SHORTCUT_PATH"
[Desktop Entry]
Name=Growtopia
Exec=env WINEPREFIX="$WINE_DIR" wine "$GT_EXE_PATH"
Type=Application
Categories=Game;
Terminal=false
Icon=applications-games
EOF
    chmod +x "$SHORTCUT_PATH"
    echo "shortcut created on your desktop."
fi

echo "==============================================="
echo "   DONE! u can play now. have fun.             "
echo "==============================================="
