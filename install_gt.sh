#!/bin/bash

# --- AYARLAR ---
DOWNLOAD_LINK="https://growtopiagame.com/Growtopia-Installer.exe"
INSTALLER_NAME="GrowtopiaSetup.exe"
WINE_DIR="$HOME/.growtopia-linux"
SHORTCUT_PATH="$HOME/Desktop/Growtopia.desktop"

clear
echo "==============================================="
echo "   Growtopia Linux Kurulum Sihirbazı v1.0      "
echo "==============================================="

# 1. SİSTEM KONTROLÜ
echo "[1/5] Bağımlılıklar kontrol ediliyor..."
dependencies=(wine wget winetricks)

for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Hata: '$cmd' sistemi kurulu değil."
        echo "Lütfen şu komutla yükle: sudo apt install wine wget winetricks"
        exit 1
    fi
done
echo "Tamam: Tüm araçlar sistemde mevcut."

# 2. DOSYALARI ÇEKME
echo "[2/5] Kurulum dosyası indiriliyor..."
if [ ! -f "$INSTALLER_NAME" ]; then
    wget -O "$INSTALLER_NAME" "$DOWNLOAD_LINK"
else
    echo "Kurulum dosyası zaten mevcut, indirme atlanıyor."
fi

if [ $? -ne 0 ]; then
    echo "Hata: Dosya indirilemedi!"
    exit 1
fi

# 3. PREFIX OLUŞTURMA
echo "[3/5] Wine prefix yapılandırılıyor ($WINE_DIR)..."
export WINEPREFIX="$WINE_DIR"
export WINEARCH=win32
winecfg /v win10 &> /dev/null

# 4. BAĞIMLILIKLAR
echo "[4/5] Windows kütüphaneleri yükleniyor (Bu işlem biraz sürebilir)..."
winetricks -q vcredist2013 vcredist2015 d3dx9

echo "Oyun kurulumu başlıyor. Lütfen Windows penceresindeki adımları tamamla..."
wine "$INSTALLER_NAME"

# 5. KISAYOL OLUŞTURMA
echo "[5/5] Masaüstü kısayolu oluşturuluyor..."
GT_EXE_PATH=$(find "$WINE_DIR" -name "Growtopia.exe" | head -n 1)

if [ -z "$GT_EXE_PATH" ]; then
    echo "Uyarı: Growtopia.exe bulunamadı. Kurulumu tamamladığından emin ol."
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
    echo "Masaüstü kısayolu başarıyla oluşturuldu."
fi

echo "==============================================="
echo "   İŞLEM TAMAMLANDI! İyi oyunlar.              "
echo "==============================================="