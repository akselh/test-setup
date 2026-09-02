# Installering av nødvendig programvare på maskinen din før Agentic Edge workshop

For at du skal kunne delta på og få fullt utbytte av planlagte workshoper med Agentic Edge kreves det at du har noen
viktige verktøy installert på din maskin. Du må i første omgang igjennom 3 hovedsteg:

1. Lage GitHub-konto og knytte denne til bedriftens GitHub-organisasjon
2. Installere noen programmer, Claude gjør det meste for deg her.
3. Kjøre [sjekken etter installasjon](check-installation.md). Den hjelper deg også med
   innloggingen til GitHub, så den trenger du ikke ordne på forhånd

## 1: Lage GitHub-konto og tilknytte til din bedrifts GitHub-organisasjon

Dersom du ikke har laget deg GitHub-konto, følg [github-account.md](github-account.md) først.
Den guiden dekker kontoen og tilgangen til bedriftens GitHub-organisasjon. Start med
den, for den tar tid hos andre enn deg.

## 2: Installer verktøy for workshopen

Workshopen trenger noen programmer. De fleste installerer sjekken i steg 3 for deg, alle faktisk dersom du har en Windows maskin.
Git må på plass først, fordi sjekken henter seg selv fra GitHub med Git. Ingenting her skal trenge administratorrettigheter.

| Program                | Hva det gjør                                                           | Hvem installerer                  |
|------------------------|------------------------------------------------------------------------|-----------------------------------|
| **Git**                | Ruller tilbake endringer som ikke virket, og deler AI-verktøy i teamet | **Du**, i dette steget — se under |
| **Visual Studio Code** | Her ser du på og endrer filene du får i workshopen                     | Sjekken i steg 3                  |
| **Node.js**            | Lager Word- og PowerPoint-filer med AI i Claude Code                   | Sjekken i steg 3                  |
| **GitHub CLI**         | Logger deg inn på GitHub, etterpå virker Git uten ny pålogging         | Sjekken i steg 3                  |

Har du Git fra før? Mest sannsynlig ikke, da dette ikke blir installert som standard. Men åpne eventuelt PowerShell (Windows) eller
Terminal (Mac), skriv `git --version` og trykk Enter. Får du et versjonsnummer, hopp til steg 3.

### Git på Windows

> **Kun Windows.** Meldingen under er bare for Windows. Har du Mac, hopp til «Git på Mac»
> lenger ned, og ikke bruk denne meldingen.

#### Installere Git med **Claude Code**

Claude Code installerer Git for deg, for din bruker alene. Claude Code er viktig da Cowork kan _ikke_ fikse dette for deg! Slik:

1. Åpne Claude. Klikk **Code** øverst til venstre, ved siden av «Chat and Cowork».

   ![Velg Code i Claude Desktop](screenshots/claude-code-in-desktop.jpg)

2. Lim inn hele denne meldingen i en ny chat, og send den:

```
Installer Git for Windows for meg, for min bruker alene, uten administratorrettigheter. Gjør nøyaktig dette i PowerShell, i denne rekkefølgen, og ikke noe annet:

1. Last ned installasjonsfilen:
   curl.exe -sL "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.5/Git-2.55.0.5-64-bit.exe" -o "$env:TEMP\Git-setup.exe"

2. Kjør installasjonen stille, med alle valg gitt på forhånd. Ikke be om administrator, og ikke bruk -Verb RunAs:
   Start-Process -FilePath "$env:TEMP\Git-setup.exe" -ArgumentList "/VERYSILENT","/NORESTART","/o:EditorOption=VisualStudioCode","/o:PathOption=Cmd","/o:CURLOption=WinSSL","/o:CRLFOption=CRLFAlways","/o:BashTerminalOption=ConHost","/o:GitPullOption=Rebase","/o:CredentialManagerOption=Enabled","/o:EnableSymlinks=Disabled" -Wait

3. Fortell Claude Code hvor Git Bash ligger:
   [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe", "User")

4. Vis meg versjonen:
   & "$env:LOCALAPPDATA\Programs\Git\cmd\git.exe" --version

5. Si til slutt at jeg må logge ut og inn igjen på Windows, eller starte maskinen på nytt, før Claude ser Git — og at jeg deretter går videre til sjekken.

Ikke bruk winget, ikke last ned fra andre adresser, og ikke endre noe annet på maskinen. Feiler et steg, vis meg den nøyaktige feilmeldingen og stopp der.
```

3. Claude laster ned Git, installerer det og viser versjonsnummeret til slutt. Det tar et par
   minutter, og installasjonen viser ingenting på skjermen mens den kjører.
4. Logg ut og inn igjen på Windows, eller start maskinen på nytt. Først da ser Claude Git.

Sperrer firmaet ditt nedlastinger eller skript, feiler meldingen, og Claude viser deg
feilmeldingen. Da installerer du Git selv med [git-install.md](git-install.md) — den viser
hvert valg i installasjonsprogrammet.

### Git på Mac

Meldingen over er ikke for Mac. På Mac kommer Git med Apples egne verktøy: åpne `Terminal`,
skriv `git --version` og trykk Enter. Mangler Git, klikk **Install** i dialogen som kommer, og
vent til nedlastingen er ferdig. Avslutt så Claude helt (Cmd+Q) og åpne det igjen. Mac
stiller ingen av spørsmålene Windows stiller.

## 3: Ferdigstill installasjoner og kjør sjekk på at alt klart

_NB! Du kan først starte dettes steget etter at du har laget GitHub-konto og denne er koblet til bedriftens GitHub-organisasjon.
Dvs. at du har mottat invitasjon til bedriftens GitHub på epost og akseptert denne invitasjonen._

Innloggingen på GitHub og kontrollen av alt over skjer i
[sjekken etter installasjon](check-installation.md). Sjekken forklarer innloggingen steg
for steg når du kommer dit.

## Etter installasjon ferdig

Du må både ha Claude installert og være innlogget med din bedriftsbruker (personlig bruker/abonnement kan ikke
brukes) på Claude for å fullføre [sjekken etter installasjon](check-installation.md).

---

_Versjonene og lenkene i denne guiden ble sist kontrollert 2026-09-01._
