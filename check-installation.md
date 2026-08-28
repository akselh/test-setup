# Sjekk maskinen din før workshopen

Denne sjekken tar noen få minutter. Den sjekker at du har nødvendig programvare installert før workshop starter.
Send resultatet av sjekken til koordinator i din bedrift for Agentic Edge workshop, se lenger ned.

## Før du starter

Du må ha Claude (Desktop applikasjon, _ikke_ websiden claude.ai) med tilgang til Claude Code, og du må være logget
inn i Claude.

## Slik gjør du det

1. Åpne Claude, og åpne Claude Code i appen.
2. Lim inn og send denne meldingen i en ny chat:

```
Klon https://github.com/akselh/test-setup til C:\dev\workshop-setup-test.
Bytt arbeidsmappe til C:\dev\workshop-setup-test.
Run the pre-workshop-check skill. After skill completes: show the output to the user and also save it to a file named  
`pre-workshop-check-<user's name>.md in the root of this project.
```
3. Send filen som blir laget til din workshop koordinator. Se instruksjoner under.

Claude gjør all sjekk. NB! Sjekken bruker lokal katalog `C:\dev`, ikke `Dokumenter`. Mappen `Dokumenter` ligger ofte i
OneDrive, og det kan gi feil.

### Dette gjør du med resultatet av sjekken

Send filen som starter med "pre-workshop-check-" til koordinator for Agentic Edge workshops i din bedrift.

## Hva sjekken gjør på maskinen din

Testene sjekker at du har nødvendig programvare for workshops installert på maskinen. Den skriver to ting, begge i den
nye mappen på disken din `C:\dev\workshop-setup-test`:

- `example.docx`, En Word-fil som er generert fra testen. Sjekker at du har Node.js og Anthropic Office Skills.
- `node_modules`, en mappe med kode som Word-testen trenger.

Begge kan du slette etterpå. Ingen av dem ligger utenfor mappen.
