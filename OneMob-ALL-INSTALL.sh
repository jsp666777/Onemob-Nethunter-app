#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "====================================="
echo "   ONE MOB – ALL DISTRO INSTALLER"
echo "   Full Nethunter Layer + Tools"
echo "====================================="

DISTROS=(
"adelie"
"almalinux"
"alpine"
"archlinux"
"artix"
"chimera"
"debian"
"deepin"
"fedora"
"manjaro"
"opensuse"
"oracle"
"pardus"
"rockylinux"
"trisquel"
"ubuntu"
"void"
)

echo "[+] Updating Termux..."
pkg update -y && pkg upgrade -y
pkg install -y proot-distro git wget curl python nano neofetch

mkdir -p ~/OneMob
echo "[+] OneMob folder created"

echo "[+] Starting FULL distro installation..."
for d in "${DISTROS[@]}"; do
    echo "--------------------------------------"
    echo "[+] Installing $d ..."
    proot-distro install $d || echo "[!] Failed to install $d, skipping."
    echo "[+] Injecting OneMob Nethunter Tools into $d..."
    
    cat << 'EOF' > /data/data/com.termux/files/usr/var/lib/proot-distro/$d/rootfs/root/nhtools.sh
apt update || true
apt install -y nmap hydra sqlmap python3-pip curl wget git || true
pip install --upgrade pip
EOF

    proot-distro login $d -- bash /root/nhtools.sh || true
    echo "[+] Finished $d"
done

echo "[+] Creating nh command..."
cat << 'EOF' > ~/../usr/bin/nh
#!/data/data/com.termux/files/usr/bin/bash
echo "Available Distros:"
proot-distro list
echo ""
echo "Usage: nh <distro>"
if [ -z "$1" ]; then exit; fi
proot-distro login "$1"
EOF

chmod +x ~/../usr/bin/nh

echo "[+] Creating OneMob menu..."
cat << 'EOF' > ~/../usr/bin/onemob
#!/data/data/com.termux/files/usr/bin/bash
clear
echo "====== ONE MOB CONTROL ======"
echo "1) List Distros"
echo "2) Login to Distro"
echo "3) Nethunter Tools"
echo "4) Update System"
echo "5) KeX Desktop"
echo "6) Exit"
read -p "Choice: " c

case $c in
1) proot-distro list ;;
2) read -p "Distro: " d; proot-distro login "$d" ;;
3) echo "Nmap, Hydra, SQLmap, Python3 installed in all." ;;
4) pkg update && pkg upgrade ;;
5) echo "Kex coming soon" ;;
6) exit ;;
*) echo "Invalid" ;;
esac
EOF

chmod +x ~/../usr/bin/onemob

echo "[+] Creating update command..."
cat << 'EOF' > ~/../usr/bin/omupdate
pkg update -y && pkg upgrade -y
EOF

chmod +x ~/../usr/bin/omupdate

echo "====================================="
echo " FULL INSTALL COMPLETE!"
echo " Commands:"
echo "    nh         → Login Nethunter distro"
echo "    onemob     → OneMob menu"
echo "    omupdate   → Update everything"
echo "====================================="
