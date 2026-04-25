# growtopia linux installer script

hi i made this simple bash script to make playing growtopia on linux easy. because usually it is a pain to setup wine and prefixes correctly so this script does it for u.

## what this script does
it creates a clean 32bit wine prefix specifically for growtopia and installs needed windows libraries like vcredist and d3d so the game wont crash.

## before u run the script
u need to install some basic stuff on your system first. depending on what linux u use run these commands:

**for ubuntu / mint / debian:**
sudo apt update
sudo apt install wine wget winetricks

**for arch linux:**
sudo pacman -S wine wget winetricks

## how to install
1. download the install_gt.sh file from this repo.
2. open terminal in the folder where the file is.
3. give it permission to run:
chmod +x install_gt.sh
4. run it:
./install_gt.sh

just follow the windows installer steps when it pops up and u are good to go.

## how to fix error 0 (important)
if u get error 0 during login it means your linux is missing some 32bit internet libraries. this is very common on linux.

**if u are on ubuntu/debian run this:**
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libgnutls30:i386 libp11-kit0:i386 libtasn1-6:i386

**if u are on arch linux run this:**
sudo pacman -S lib32-gnutls

after u do this the error 0 should be gone and u can play online.

## requirements and libraries
the script automatically tries to install these via winetricks:
- vcredist2013
- vcredist2015
- d3dx9
- wininet (if needed)

## notes
i am not responsible for any bans or issues with your account. this is just a tool to help linux users. growtopia is owned by ubisoft. i made this for my friends but anyone can use it.

if the script fails check if u have internet and try again.
