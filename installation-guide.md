# Installering av nødvendig programvare på maskinen din før Agentic Edge workshop

For at du skal kunne delta på og få fullt utbytte av planlagte workshoper med Agentic Edge kreves det at du har noen 
viktige verktøy installert på din maskin. Du må i første omgang igjennom 3 hovedsteg:

1. Lage GitHub-konto og knytte denne til bedriftens GitHub-organisasjon
2. Installere noen programmer
3. Sjekke at innlogging til GitHub-kontoen din fungerer fra lokal maskin
   - **Merk**: Dette steget kan du ikke gjøre før du er ferdig med alt i steg 1, se [github-account.md](github-account.md)
   
## 1: Lage GitHub-konto og tilknytte til din bedrifts GitHub-organisasjon
Dersom du ikke har laget deg GitHub-konto, følg [github-account.md](github-account.md) først.
Den guiden dekker kontoen, tofaktor og tilgangen til bedriftens GitHub-organisasjon. Start med
den, for den tar tid hos andre enn deg.

## 2: Installer verktøy for workshopen

Kolonnen «Alle» gjelder alle maskiner. Les så kolonnen for din maskin.

| Program | Alle | Windows | macOS |
| --- | --- | --- | --- |
| **Visual Studio Code** | Her ser du på og endrer filene du får i workshopen. Last ned fra [code.visualstudio.com](https://code.visualstudio.com/) | Velg «User Installer». Den trenger ikke administrator | Pakk ut filen du laster ned, og dra `Visual Studio Code` inn i mappen `Programmer` |
| **Git** | Git ruller tilbake endringer som ikke virket, og deler AI-verktøy i teamet | Last ned fra [git-scm.com](https://git-scm.com/download/win). Installasjonsprogrammet stiller mange spørsmål, og [git-install.md](git-install.md) viser deg hvert valg. Den siden har også én kommando som svarer på alle åtte for deg | Åpne `Terminal`, skriv `git --version` og trykk Enter. Mangler Git, klikk `Install` i dialogen og vent. Mac stiller ingen av spørsmålene Windows stiller |
| **Node.js** | Node.js lager Word- og PowerPoint-filer med AI i Claude Code. Last ned fra [nodejs.org](https://nodejs.org/en/download) | Velg «Windows Installer», eller bruk [denne linken](https://nodejs.org/dist/v24.20.0/node-v24.20.0-x64.msi). **NB!** Ikke bruk `winget install OpenJS.NodeJS.LTS`. Den legger ofte ikke Node.js på PATH | Velg «macOS Installer», eller bruk [denne linken](https://nodejs.org/dist/v24.20.0/node-v24.20.0.pkg). Filen virker på både Apple Silicon (M1 til M4) og Intel |
| **GitHub CLI** | Logger deg inn på GitHub én gang. Etterpå virker `git clone` og `git push` uten passord, uten tilgangsnøkkel og uten SSH-nøkkel. Last ned fra [cli.github.com](https://cli.github.com/) | Bruk [denne linken](https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_windows_amd64.msi) | Bruk [denne linken](https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_universal.pkg). Filen virker på både Apple Silicon (M1 til M4) og Intel. Installasjonen ber om administrator-passordet ditt — har du ikke det, se «GitHub CLI uten administratorrettigheter» under |

Windows kan spørre «Vil du tillate at denne appen gjør endringer?» under installasjonen.
Klikk **Ja**. Får du ikke lov, ta kontakt med koordinator i din bedrift — eller bruk
fremgangsmåten under for GitHub CLI.

### GitHub CLI uten administratorrettigheter

GitHub CLI er ett enkelt program, så det kan legges i hjemmemappen din uten administrator.
Enklest: hopp over dette og la [sjekken før workshopen](check-installation.md) gjøre det for
deg — den oppdager at GitHub CLI mangler og tilbyr å installere det slik. Vil du heller gjøre
det selv, følger du fremgangsmåten under.

**macOS:** Åpne `Terminal`, lim inn hele blokken under, og trykk Enter. Det er viktig at du
laster ned via Terminal (ikke nettleseren), ellers kan macOS blokkere programmet.

```bash
ARK=$(uname -m | sed 's/x86_64/amd64/')
curl -sL "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_${ARK}.zip" -o /tmp/gh.zip
unzip -oq /tmp/gh.zip -d /tmp
mkdir -p ~/.local/bin
cp "/tmp/gh_2.98.0_macOS_${ARK}/bin/gh" ~/.local/bin/
grep -q '.local/bin' ~/.zprofile 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile
~/.local/bin/gh --version
```

Siste linje skal skrive versjonsnummeret. Avslutt så Claude helt (Cmd+Q) og åpne det igjen.

**Windows:** Last ned [zip-filen](https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_windows_amd64.zip)
i stedet for MSI-filen. Åpne `PowerShell`, lim inn blokken under, og trykk Enter:

```powershell
Expand-Archive "$env:USERPROFILE\Downloads\gh_2.98.0_windows_amd64.zip" -DestinationPath "$env:LOCALAPPDATA\Programs\gh" -Force
$p=[Environment]::GetEnvironmentVariable("Path","User"); $b="$env:LOCALAPPDATA\Programs\gh\bin"
if ($p -notlike "*$b*") { [Environment]::SetEnvironmentVariable("Path", ($p.TrimEnd(";") + ";" + $b), "User") }
& "$env:LOCALAPPDATA\Programs\gh\bin\gh.exe" --version
```

Siste linje skal skrive versjonsnummeret. Logg så ut og inn av Windows.

Etter at du har installert Git, Node.js og GitHub CLI, må programmene som kjørte under
installasjonen startes på nytt før de ser de nye verktøyene:

- **Windows:** Start maskinen på nytt, eller logg ut og inn igjen. Først da ser Claude dem.
- **macOS:** Avslutt Claude helt (Cmd+Q) og åpne det igjen. Du trenger ikke starte maskinen
  på nytt.

## 3: Logg inn på GitHub

Dette steget kan først gjøres etter du har mottatt e-post og godtatt GitHub-invitasjonen fra
[github-account.md](github-account.md). I tillegg må GitHub CLI beskrevet over være installert.

1. Åpne `PowerShell` på Windows, eller `Terminal` på Mac.
2. Skriv denne kommandoen og trykk Enter:

```
gh auth login
```

3. Svar på spørsmålene med piltastene og Enter:
   - «What account do you want to log into?» → **GitHub.com**
   - «What is your preferred protocol for Git operations?» → **HTTPS**
   - «Authenticate Git with your GitHub credentials?» → **Yes**. Dette svaret er det viktigste.
     Det gjør at Git bruker innloggingen din
   - «How would you like to authenticate?» → **Login with a web browser**
4. Kommandoen viser en kode på åtte tegn, for eksempel `A1B2-C3D4`. Kopier koden.
5. Trykk Enter. Nettleseren åpner seg. Lim inn koden og godkjenn.
6. Terminalen skriver `Logged in as <brukernavnet ditt>`. Da er du ferdig.

[Sjekken etter installasjon](check-installation.md) kontrollerer at innloggingen virker,
og at du har tilgang til organisasjonen.

## Etter installasjon ferdig

Du må både ha Claude installert og være innlogget med din bedriftsbruker (personlig bruker/abonnement kan ikke 
brukes) på Claude for å fullføre [sjekken etter installasjon](check-installation.md).

---

_Versjonene og lenkene i denne guiden ble sist kontrollert 2026-09-01._
