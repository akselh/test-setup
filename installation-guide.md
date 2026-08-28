# Installering av nødvendig programvare på maskinen din før Agentic Edge workshoper

For at du skal kunne delta på og få fullt utbytte av planlagte workshoper med Agentic Edge kreves det at du har noen 
viktige verktøy installert på din maskin,

## Installer disse verktøyene 

Installer disse i angitt rekkefølge. Noen steg er ulike på Windows og Mac.

- Visual Studio Code: last ned og installer fra Microsoft sin side https://code.visualstudio.com/
  - Mac: pakk ut filen du laster ned, og dra `Visual Studio Code` inn i mappen `Programmer`
  - Dette verktøyet vil du bl.a. bruke for å se på og evt. endre med AI-verktøy og filer som du får i workshopen
- Git: last ned og installer Git her
  - Windows: https://git-scm.com/install/windows
    - Installasjonsprogrammet stiller mange spørsmål. [git-install.md](git-install.md) viser deg hvert valg
  - Mac: åpne programmet `Terminal`, skriv `git --version` og trykk Enter
    - Mangler Git, spør maskinen om du vil installere «Command Line Tools». Klikk `Install` og vent
    - Mac stiller ingen av spørsmålene som Windows stiller
    - Du kan også laste ned Git her: https://git-scm.com/install/mac
  - Git brukes bl.a. for å rulle tilbake endringer på filer som ikke fungerte, samt å dele AI-verktøy m.m. inad i teamet
- Node.js: last ned og installer fra https://nodejs.org/en/download 
  - For Windows: Velg "Windows Installer" nede på siden eller bruk denne linken
    - https://nodejs.org/dist/v24.20.0/node-v24.20.0-x64.msi
    - NB! Ikke bruk `winget install OpenJS.NodeJS.LTS`. Den installasjonen legger ofte ikke Node.js på PATH.
  - For Mac: Velg "macOS Installer" på siden eller bruk denne linken
    - https://nodejs.org/dist/v24.20.0/node-v24.20.0.pkg
    - Denne filen virker på både Apple Silicon (M1 til M4) og Intel
  - Node.js brukes for å kunne generere bl.a. Word-dokumenter med AI i Claude Code

Start maskinen på nytt etter at du har installert Node.js og Git. Først da ser Claude dem

Det er forventet at du allerede bruker Claude (desktop applikasjon). Dersom dette ikke er tilfelle må du kontakte
workshop koordinator for å få en bruker på Claude instruks for installasjon av Claude. 

## Etter installasjon ferdig

Du må både ha Claude installert og vere innlogget med din bedriftsbruker (personlig bruker/abonnement kan ikke 
brukes) på Claude for å fullføre [sjekken etter installasjon](check-installation.md).
