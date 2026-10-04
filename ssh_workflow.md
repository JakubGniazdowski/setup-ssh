# 🚀 Błyskawiczna Konfiguracja SSH (setup-ssh)

Mój prywatny skrypt do pełnej automatyzacji stawiania bezpiecznego serwera SSH na świeżo zainstalowanym systemie Linux (Arch/Mint). Zapewnia mi natychmiastowe logowanie z mojego laptopa przy użyciu moich kluczy publicznych z GitHuba.

## 🛠️ Jak tego użyć?

Siedząc fizycznie przed nowym komputerem, loguję się na swoje konto i wpisuję w terminalu:

\`\`\`bash
curl -sL raw.githubusercontent.com/JakubGniazdowski/setup-ssh/main/setup_ssh.sh | bash
\`\`\`

## 🧠 Co skrypt robi w tle?

1. **Wykrywa system:** `pacman` (Arch) lub `apt` (Mint/Ubuntu).
2. **Instaluje usługi:** OpenSSH i zaporę UFW.
3. **Zabezpiecza port:** Ustawia regułę `limit` w UFW (ochrona przed atakami brute-force).
4. **Autoryzuje klucze:** Pobiera moje klucze z `https://github.com/JakubGniazdowski.keys` i bezpiecznie przypisuje je do maszyny.
5. **Generuje komendę:** Skrypt sam sprawdza moją nazwę użytkownika na nowym komputerze oraz jego adres IP.

## 💻 Logowanie

Na samym końcu skrypt wypluwa mi na ekran gotową linijkę. Wracam na swój główny laptop, otwieram WezTerm i wpisuję wygenerowaną komendę, na przykład:

\`\`\`bash
ssh jakub@192.168.1.50
\`\`\`

Wchodzę od razu, bezpiecznie i bez wpisywania hasła.