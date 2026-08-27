# Sjekk maskinen din før workshopen

Denne sjekken tar to minutter. Den installerer ingenting. Du sender ett
svar til kursholder når den er ferdig.

## Før du starter

Du må ha Claude Code i Claude Desktop, og du må være logget inn. Det er
kravet for å delta. Har du ikke det, si fra til kursholder nå.

## Slik gjør du det

1. Åpne Claude Desktop.
2. Åpne Claude Code i appen.
3. Åpne mappen du klonet dette repoet til som prosjekt. Bruk `C:\dev`, ikke
   `Dokumenter`. Mappen `Dokumenter` ligger ofte i OneDrive, og det gir feil.
4. Skriv denne meldingen til Claude:

```
Kjør preflight-sjekken i dette prosjektet.
```

Claude gjør resten. Den lager en Word-fil av `example.md`, sjekker VS Code,
og skriver en rapport.

## Hva du sender til kursholder

Claude skriver en rapport nederst i svaret. Rapporten starter med
`=== RAPPORT TIL KURSHOLDER ===`. Kopier hele blokken, og send den på
e-post til kursholder.

Rapporten sier én av to ting:

- `MASKINEN ER KLAR FOR WORKSHOP` — du er ferdig. Send rapporten likevel.
- `MASKINEN MANGLER: ...` — rapporten sier hva som mangler, og hvor du får
  det. Fiks det du kan selv. Send rapporten uansett, også når du ikke får
  fikset alt.

## Hvis noe krever IT

To ting kan du ikke fikse selv:

- VS Code er for gammel, og IT styrer oppdateringene.
- Nettverket til firmaet blokkerer npm.

Send rapporten til kursholder. Kursholder tar det med IT før workshopen.

## Hva sjekken gjør på maskinen din

Sjekken leser maskinen. Den skriver to ting, begge i denne mappen:

- `example.docx`, Word-filen fra testen.
- `node_modules`, en mappe med kode som Word-testen trenger.

Begge kan du slette etterpå. Ingen av dem ligger utenfor denne mappen.
