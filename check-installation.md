# Sjekk maskinen din før workshopen

Denne sjekken tar noen få minutter. Den sjekker at du har nødvendig programvare installert før
workshop starter. Send resultatet av sjekken til koordinator i din bedrift for Agentic Edge
workshop, se lenger ned.

## Før du starter

Du trenger dette før du starter:

1. Du har gjort [github-account.md](github-account.md): du har en GitHub-konto
   med 2FA (2-faktor autentisering), og du har godtatt GitHub-invitasjonen fra din bedrift.
2. Du har installert VS Code, Git, Node.js og GitHub CLI, se
   [installation-guide.md](installation-guide.md).
3. Du har kjørt `gh auth login`, se [installation-guide.md](installation-guide.md).

Og så må du ha Claude (Desktop applikasjon, _ikke_ websiden claude.ai) med tilgang til Claude Code, og du er logget 
inn i Claude med brukeren tildelt av din bedrift. Claude er ikke med i denne installasjonsguiden da det er 
forutsatt at du bruker Claude allerede.

Har du hoppet over noe av dette, går sjekken likevel: den finner det som mangler, hjelper deg
å fikse det du kan fikse der og da, og skriver resten i rapporten.

## Slik gjør du det

1. Åpne Claude. Klikk **Code** øverst til venstre, ved siden av «Chat and Cowork».

   ![Velg Code i Claude Desktop](screenshots/claude-code-in-desktop.jpg)

2. Lim inn og send denne meldingen i en ny chat.

   På **Windows**:

```
Dersom mappen C:\dev\workshop-setup-test ikke finnes: Klon https://github.com/akselh/test-setup til C:\dev\workshop-setup-test, bytt så arbeidsmappe dit.
Dersom mappen finnes, bytt til denne mappen som arbeidsmappe.

Kjør pre-workshop-check skillen.
```

   På **Mac**:

```
Dersom mappen ~/dev/workshop-setup-test ikke finnes: Klon https://github.com/akselh/test-setup til ~/dev/workshop-setup-test, bytt så arbeidsmappe dit.
Dersom mappen finnes, bytt til denne mappen som arbeidsmappe.

Kjør pre-workshop-check skillen.
```

3. Claude stiller deg noen spørsmål underveis, blant annet om navnet ditt. Mangler et program
   helt, spør Claude om du vil installere det nå, og viser deg lenken. Svar på spørsmålene, så
   blir mest mulig fikset før rapporten skrives.
4. Send filen som blir laget til din workshop koordinator. Se instruksjoner under.

Claude gjør all sjekk. NB! Sjekken bruker en egen `dev`-mappe, ikke `Dokumenter`. Mappen
`Dokumenter` ligger ofte i OneDrive eller iCloud, og det kan gi feil.

**Feiler selve kloningen?** Da mangler du sannsynligvis Git, eller nettverket ditt stopper
GitHub. Dette prosjektet er åpent, så kloningen trenger ingen tilgang til bedriftens organisasjon. 
Be Claude i samme chat om å laste ned prosjektet fra samme GitHub-adresse som ZIP og pakke det ut i samme mappe i 
stedet. Kjør så sjekken derfra — den vil da oppdage hva som mangler og hjelpe deg å fikse det.

### Dette gjør du med resultatet av sjekken

Send filen som starter med `pre-workshop-check-` til koordinator for Agentic Edge workshops i din
bedrift.

## Hva sjekken gjør på maskinen din

Sjekken leser først om Node.js (med npm), Git, VS Code og GitHub CLI er installert. Mangler et
av dem helt, spør sjekken om du vil installere det nå. Sier du nei, eller feiler installasjonen,
skriver sjekken det i rapporten, med lenke.

Deretter kontrollerer sjekken at du er logget inn på GitHub, og at du får lest et repository i
bedriftens organisasjon. Så kloner den bedriftens workshop-repository til `dev`-mappen, slik at
du møter til workshopen med alt klart (innholdet i workshop-repository får du først i workshopen).
Til slutt lager den en Word-fil og en PowerPoint-fil, for å vise at eksporten virker.

Sjekken skriver fire ting i den nye mappen på disken din. Mappen heter
`C:\dev\workshop-setup-test` på Windows og `~/dev/workshop-setup-test` på Mac:

- `word-example.docx`, en Word-fil laget fra `word-example.md`.
- `powerpoint-example.pptx`, en PowerPoint-fil laget fra `powerpoint-example.md`.
- `node_modules`, en mappe med kode som Word- og PowerPoint-testen trenger.
- `pre-workshop-check-<navnet ditt>.md`, rapporten du sender til koordinator.

Alle fire kan du eventuelt slette etterpå. I tillegg legger sjekken bedriftens workshop-repository i en
egen mappe ved siden av, i `dev`-mappen. **Den mappen beholder du** — det er den du bruker i
workshopen.

Sjekken installerer ingen programmer selv, med ett unntak: mangler GitHub CLI, kan sjekken
legge det i hjemmemappen din for deg — det trenger ikke administratorrettigheter, og sjekken
spør deg først. Mangler et av de andre programmene, spør den om du vil installere det nå — du
klikker da selv gjennom installasjonen mens sjekken venter. Den logger
deg heller ikke inn på GitHub. Mangler innloggingen, ber sjekken deg kjøre `gh auth login` i et
eget terminalvindu, og fortsetter når du er ferdig. Se [installation-guide.md](installation-guide.md).

Sjekken kan endre disse tingene, og den spør deg først hver gang:

- PATH-en din, hvis Node.js eller Git ligger på disken, men Claude ikke finner dem.
- GitHub CLI kan den installere i hjemmemappen din, hvis det mangler helt.
- Navnet og e-postadressen din i Git, hvis du ikke har satt dem fra før.
- Innstillingen for sertifikater i npm, hvis firmaets brannmur stopper nedlastingen.
  Sjekken kopierer da sertifikatene fra Windows til filen `windows-root-ca.pem` i
  hjemmemappen din.
