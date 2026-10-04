#!/bin/bash
set -e

GITHUB_USER="JakubGniazdowski"
SSH_DIR="$HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
CURRENT_USER=$(whoami)
LOCAL_IP=$(hostname -I | awk '{print $1}')

echo "⚙️ Instalacja serwera SSH i zapory..."
if command -v apt &> /dev/null; then
    sudo apt update -qq
    sudo apt install -y openssh-server ufw
    sudo systemctl enable --now ssh
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm openssh ufw
    sudo systemctl enable --now sshd
else
    echo "❌ Nieobsługiwany system. Zainstaluj OpenSSH i UFW ręcznie."
    exit 1
fi

echo "🔒 Konfiguracja zapory (UFW)..."
sudo ufw limit ssh comment 'Rate limit for SSH' > /dev/null
sudo ufw --force enable > /dev/null

echo "🔑 Pobieranie kluczy z GitHuba dla użytkownika: $GITHUB_USER..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

curl -s "https://github.com/${GITHUB_USER}.keys" >> "$AUTHORIZED_KEYS"
sort -u "$AUTHORIZED_KEYS" -o "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

echo ""
echo "✨ Gotowe! Serwer działa, klucze autoryzowane."
echo "Wklej to na swoim głównym komputerze, aby się połączyć:"
echo "👉 ssh ${CURRENT_USER}@${LOCAL_IP}"