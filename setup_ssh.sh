#!/bin/bash
set -e

GITHUB_USER="JakubGniazdowski"
SSH_DIR="$HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
CURRENT_USER=$(whoami)
OS_NAME=$(uname -s)

echo "⚙️ Instalacja i konfiguracja serwera SSH..."
if [[ "$OS_NAME" == "Darwin" ]]; then
    echo "🍎 Wykryto macOS. Włączanie funkcji Remote Login..."
    sudo systemsetup -setremotelogin on
elif command -v apt &> /dev/null; then
    sudo apt update -qq
    sudo apt install -y openssh-server ufw
    sudo systemctl enable --now ssh
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm openssh ufw
    sudo systemctl enable --now sshd
elif command -v dnf &> /dev/null; then
    sudo dnf install -y openssh-server ufw
    sudo systemctl enable --now sshd
elif command -v yum &> /dev/null; then
    sudo yum install -y openssh-server ufw
    sudo systemctl enable --now sshd
elif command -v zypper &> /dev/null; then
    sudo zypper --non-interactive install openssh ufw
    sudo systemctl enable --now sshd
elif command -v apk &> /dev/null; then
    sudo apk add openssh ufw
    sudo rc-update add sshd default
    sudo service sshd start
elif [[ "$OS_NAME" == "MINGW"* || "$OS_NAME" == "MSYS"* || "$OS_NAME" == "CYGWIN"* ]]; then
    echo "❌ Windows nie obsługuje tego skryptu natywnie."
    echo "   Uruchom go w WSL albo skonfiguruj OpenSSH i zaporę w PowerShell."
    exit 1
else
    echo "❌ Nieobsługiwany system. Zainstaluj OpenSSH i zaporę ręcznie."
    exit 1
fi

if [[ "$OS_NAME" == "Darwin" ]]; then
    echo "ℹ️ macOS używa własnej zapory systemowej; konfiguracja UFW jest pomijana."
else
    echo "🔒 Konfiguracja zapory (UFW)..."
    sudo ufw limit ssh comment 'Rate limit for SSH' > /dev/null
    sudo ufw --force enable > /dev/null
fi

echo "🔑 Pobieranie kluczy z GitHuba dla użytkownika: $GITHUB_USER..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

TEMP_KEYS=$(mktemp)
trap 'rm -f "$TEMP_KEYS"' EXIT
curl -fsSL "https://github.com/${GITHUB_USER}.keys" -o "$TEMP_KEYS"
cat "$TEMP_KEYS" >> "$AUTHORIZED_KEYS"
sort -u "$AUTHORIZED_KEYS" -o "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

if [[ "$OS_NAME" == "Darwin" ]]; then
    DEFAULT_INTERFACE=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
    LOCAL_IP=$(ipconfig getifaddr "$DEFAULT_INTERFACE" 2>/dev/null || true)
else
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    if [[ -z "$LOCAL_IP" ]] && command -v ip &> /dev/null; then
        LOCAL_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i == "src") {print $(i+1); exit}}')
    fi
fi

echo ""
echo "✨ Gotowe! Serwer działa, klucze autoryzowane."
echo "IP tego komputera: ${LOCAL_IP:-nie udało się wykryć}"
if [[ -n "$LOCAL_IP" ]]; then
    echo "Połącz się poleceniem: ssh ${CURRENT_USER}@${LOCAL_IP}"
else
    echo "👉 Sprawdź adres IP ręcznie i połącz się jako: ssh ${CURRENT_USER}@<adres-IP>"
fi