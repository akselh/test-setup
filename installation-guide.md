# Installering av nødvendig programvare på maskinen din før Agentic Edge workshop

For at du skal kunne delta på og få fullt utbytte av planlagte workshoper med Agentic Edge kreves det at du har noen 
viktige verktøy installert på din maskin. Du må i første omgang igjennom 3 hovedsteg:

1. Lage GitHub-konto og knytte denne til bedriftens GitHub-organisasjon
2. Installere noen programmer
3. Kjøre [sjekken etter installasjon](check-installation.md). Den hjelper deg også med
   innloggingen til GitHub, så den trenger du ikke ordne på forhånd
   
## 1: Lage GitHub-konto og tilknytte til din bedrifts GitHub-organisasjon
Dersom du ikke har laget deg GitHub-konto, følg [github-account.md](github-account.md) først.
Den guiden dekker kontoen og tilgangen til bedriftens GitHub-organisasjon. Start med
den, for den tar tid hos andre enn deg.

## 2: Installer verktøy for workshopen

Kolonnen «Alle» gjelder alle maskiner. Les så kolonnen for din maskin.

| Program | Alle                                                                                                                                                               | Windows                                                                                                                                                                                                                                | macOS                                                                                                                                                          |
| --- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Visual Studio Code** | Her ser du på og endrer filene du får i workshopen. Last ned fra [code.visualstudio.com](https://code.visualstudio.com/)                                           | Velg «User Installer». Den trenger ikke administrator                                                                                                                                                                                  | Pakk ut filen du laster ned, og dra `Visual Studio Code` inn i mappen `Programmer`                                                                             |
| **Git** | Git ruller tilbake endringer som ikke virket, og deler AI-verktøy i teamet                                                                                         | Last ned fra [git-scm.com](https://git-scm.com/download/win). Installasjonsprogrammet stiller mange spørsmål, og [git-install.md](git-install.md) viser deg hvert valg. Den siden har også én kommando som svarer på alle åtte for deg | Åpne `Terminal`, skriv `git --version` og trykk Enter. Mangler Git, klikk `Install` i dialogen og vent. Mac stiller ingen av spørsmålene Windows stiller       |
| **Node.js** | Node.js lager Word- og PowerPoint-filer med AI i Claude Code. Installasjon håndteres automatisk av AI fra [check-installation](check-installation.md)              | -                                                                                                                                                                                                                                      | -                                                                                                                                                              |
| **GitHub CLI** | Logger deg inn på GitHub, etterpå skal git virke uten ny pålogging. Installasjon håndteres automatisk av AI fra [check-installation](check-installation.md) | -                                                                                                                                                                                                                                      | -                                                                                                                                                              |

Windows kan spørre «Vil du tillate at denne appen gjør endringer?» under installasjonen.
Klikk **Ja**. Får du ikke lov, ta kontakt med koordinator i din bedrift.

Etter at du har installert Git, må programmene som kjørte under installasjonen
startes på nytt før de ser det nye verktøyet:

- **Windows:** Start maskinen på nytt, eller logg ut og inn igjen. Først da ser Claude dem.
- **macOS:** Avslutt Claude helt (Cmd+Q) og åpne det igjen. Du trenger ikke starte maskinen
  på nytt.

## 3: Kjør sjekken

Innloggingen på GitHub og kontrollen av alt over skjer i
[sjekken etter installasjon](check-installation.md). Sjekken forklarer innloggingen steg
for steg når du kommer dit.

## Etter installasjon ferdig

Du må både ha Claude installert og være innlogget med din bedriftsbruker (personlig bruker/abonnement kan ikke 
brukes) på Claude for å fullføre [sjekken etter installasjon](check-installation.md).

---

_Versjonene og lenkene i denne guiden ble sist kontrollert 2026-09-01._
