# Installering av nødvendig programvare på maskinen din før Agentic Edge workshoper

For at du skal kunne delta på og få fullt utbytte av planlagte workshoper med Agentic Edge kreves det at du har noen 
viktige verktøy installert på din maskin,

Gjør delene under i rekkefølge. Del 1 tar tid hos andre enn deg, så start med den.

## Del 1: GitHub-konto og tilgang til bedriftens GitHub organisasjon

I workshopen henter du AI verktøy m.m. fra et prosjekt/repository i din bedrifts GitHub-organisasjon. 
Du trenger en GitHub-konto, og GitHub-admin i bedriften må legge deg til i organisasjonen. 

1. Har du allerede en GitHub-konto? Da hopper du til punkt 3.
2. Lag en privat GitHub-konto på https://github.com/signup. 
   - Du kan fritt velge brukernavn på GitHub. Disse er som regel ganske korte, fint med noe som har 
     med eks. fornavnet ditt.
   - Legg også inn ditt fulle navn på kontoen.
   - Du kan bruke privat e-postadresse.
3. Slå på tofaktor (2FA). GitHub krever det av alle brukere.
   - Du finner valget under Settings, så Password and authentication
   - Du trenger en autentiseringsapp på telefonen, for eksempel Microsoft Authenticator
   - Ta vare på gjenopprettingskodene GitHub gir deg. Uten dem mister du kontoen
4. Send GitHub-brukernavnet ditt til GitHub-administrator i din bedrift.
5. Administrator inviterer deg til bedriftens GitHub-konto (organisasjonen). Du får en e-post fra GitHub.
   Åpne e-posten og klikk **Join** for å godta invitasjonen.

## Del 2: Installer disse verktøyene 

Installer disse i rekkefølgen tabellen viser. Kolonnen «Alle» gjelder alle maskiner.
Les så kolonnen for din maskin.

| Program | Beskrivelse                                                                                                                                                                        | Windows | macOS |
| --- |-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| **Visual Studio Code** | Her ser du på og endrer filene du får i workshopen. Last ned fra [code.visualstudio.com](https://code.visualstudio.com/)                                                                | Kjør installasjonsfilen. Behold standardvalgene | Pakk ut filen du laster ned, og dra `Visual Studio Code` inn i mappen `Programmer` |
| **Git** | Git ruller tilbake endringer som ikke virket, og deler AI-verktøy i teamet                                                                                                              | Last ned fra [git-scm.com](https://git-scm.com/download/win). Installasjonsprogrammet stiller mange spørsmål, og [git-install.md](git-install.md) viser deg hvert valg | Åpne `Terminal`, skriv `git --version` og trykk Enter. Mangler Git, klikk `Install` i dialogen og vent. Mac stiller ingen av spørsmålene Windows stiller |
| **Node.js** | Node.js lager Word- og PowerPoint-filer med AI i Claude Code. Last ned fra [nodejs.org](https://nodejs.org/en/download)                                                                 | Velg «Windows Installer», eller bruk [denne linken](https://nodejs.org/dist/v24.20.0/node-v24.20.0-x64.msi). **NB!** Ikke bruk `winget install OpenJS.NodeJS.LTS`. Den legger ofte ikke Node.js på PATH | Velg «macOS Installer», eller bruk [denne linken](https://nodejs.org/dist/v24.20.0/node-v24.20.0.pkg). Filen virker på både Apple Silicon (M1 til M4) og Intel |
| **GitHub CLI** | Logger deg inn på GitHub én gang. Etterpå virker `git clone` og `git push` uten passord, uten tilgangsnøkkel og uten SSH-nøkkel. Last ned fra [cli.github.com](https://cli.github.com/) | Velg «Windows — download the MSI», eller bruk [denne linken](https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_windows_amd64.msi) | Bruk [denne linken](https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_universal.pkg). Filen virker på både Apple Silicon (M1 til M4) og Intel |

Start maskinen på nytt etter at du har installert Node.js, Git og GitHub CLI. Først da ser Claude dem

Det er forventet at du allerede bruker Claude (desktop applikasjon). Dersom dette ikke er tilfelle må du kontakte
workshop koordinator for å få en bruker på Claude instruks for installasjon av Claude. 

## Del 3: Logg inn på GitHub

Gjør dette etter omstarten, og etter at du har godtatt invitasjonen i del 1.

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

Sjekken i neste del kontrollerer at innloggingen virker, og at du har tilgang til
organisasjonen.

## Etter installasjon ferdig

Du må både ha Claude installert og vere innlogget med din bedriftsbruker (personlig bruker/abonnement kan ikke 
brukes) på Claude for å fullføre [sjekken etter installasjon](check-installation.md).
