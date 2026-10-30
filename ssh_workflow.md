# 🚀 Błyskawiczna Konfiguracja SSH (setup-ssh)

Mój prywatny skrypt do pełnej automatyzacji stawiania bezpiecznego serwera SSH na świeżo zainstalowanym systemie Linux, macOS lub środowisku WSL.

## 🛠️ Jak tego użyć?

Siedząc fizycznie przed nowym komputerem, loguję się na swoje konto i wpisuję w terminalu:

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/JakubGniazdowski/setup-ssh/main/setup_ssh.sh | bash
\`\`\`

## 🧠 Co skrypt robi w tle?

1. **Wykrywa system:** macOS oraz dystrybucje Linuksa z `apt`, `pacman`, `dnf`, `yum`, `zypper` lub `apk`.
2. **Instaluje usługi:** OpenSSH i zaporę UFW na Linuksie; na macOS włącza systemową funkcję Remote Login.
3. **Zabezpiecza port:** Ustawia regułę `limit` w UFW na Linuksie. macOS korzysta z własnej zapory systemowej.
4. **Autoryzuje klucze:** Pobiera moje klucze z `https://github.com/JakubGniazdowski.keys` i bezpiecznie przypisuje je do maszyny.
5. **Generuje komendę:** Skrypt sam sprawdza moją nazwę użytkownika na nowym komputerze oraz jego adres IP.
   Na końcu zawsze wyświetla wykryty adres IP i gotowe polecenie `ssh`.

> Windows nie uruchamia tego skryptu natywnie. Użyj WSL albo skonfiguruj OpenSSH
> Server w PowerShell.

## 💻 Logowanie

Na samym końcu skrypt wypluwa mi na ekran gotową linijkę. Wracam na swój główny laptop, otwieram WezTerm i wpisuję wygenerowaną komendę, na przykład:

\`\`\`bash
ssh jakub@192.168.1.50
\`\`\`

Wchodzę od razu, bezpiecznie i bez wpisywania hasła.