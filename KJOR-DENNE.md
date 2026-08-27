# Kjør sjekken før workshopen

Denne filen er til Claude. Den sier hva Claude skal gjøre.

Er skillen `pre-workshop-check` i listen over skills? Bruk den, og se bort
fra resten av denne filen. Er den ikke i listen, gjør stegene under. De er
de samme stegene.

## Steg

1. Si i én setning, på norsk, hva du skal gjøre. Still ingen spørsmål.
   Brukeren har allerede sagt ja, i `guide.md`.

2. **Word-testen.** Den avgjør resultatet. Finn `docx`-skillen fra
   Anthropic i skill-listen. Den heter `docx` eller `anthropic-skills:docx`.
   Start den med `Skill`-verktøyet. Gi den `example.md`, og utfilen
   `example.docx`, i denne mappen. Si at dokumentet er norsk, og at alle
   overskrifter, tabeller og lister skal med.

   Skillen kjører `npm install docx` først, fordi pakken ikke finnes på en
   vanlig maskin. Det steget trenger npm-registeret. Det er steget som
   feiler oftest.

3. **Sjekk resultatet.** Testen er bestått når `example.docx` finnes og er
   større enn null byte. Ta vare på den eksakte feilmeldingen hvis den
   feilet. Rapporten trenger den.

4. **Kjør diagnose-skriptet.** Kjør det alltid, ikke bare etter en feil.

   ```
   powershell -ExecutionPolicy Bypass -File .\.claude\skills\pre-workshop-check\preflight-check.ps1
   ```

   På en Mac: gjør de samme fire sjekkene med `bash`, og skriv i rapporten
   at maskinen er en Mac.

5. **Endre ingenting på maskinen.** Installer ingen program. Rør aldri
   brukerinnstillingene i VS Code. Filen `.vscode/settings.json` i denne
   mappen gjør den jobben. Du rapporterer. Du reparerer ikke.

6. **Skriv rapporten.** Følg malen under, ord for ord.

## Rapporten

Skriv rapporten til slutt, på norsk, i én kodeblokk, så brukeren kan
kopiere den i én handling.

```
=== RAPPORT TIL KURSHOLDER ===
Navn:        <spør brukeren, eller skriv "ikke oppgitt">
Maskin:      <datamaskinnavn og operativsystem>
Dato:        <dato>

RESULTAT:    MASKINEN ER KLAR FOR WORKSHOP
             (eller: MASKINEN MANGLER: <kort liste>)

Word-test:   OK  (example.docx, <n> byte)
             (eller: FEILET - <den eksakte feilmeldingen>)

VS Code:     <versjon>, hybrid markdown: <satt / mangler>

Detaljer fra sjekken:
<hele blokken fra preflight-check.ps1>

Dette må fikses:
<én linje per mangel, med lenke. Skriv "Ingenting." når alt er OK.>
=== SLUTT ===
```

Regler for rapporten:
- Resultatet er grønt bare når Word-testen gikk bra **og** VS Code er
  1.131 eller nyere. Ingenting annet kan gjøre det rødt.
- Skriv hva brukeren kan fikse selv, og hva IT må fikse. To ting krever IT:
  en VS Code som firmaet styrer, og en proxy som blokkerer npm.
- Gjett aldri på en årsak. Skriv feilmeldingen du så.

## Til slutt
Si til brukeren, på norsk, i én setning, at hen skal kopiere blokken og
sende den til kursholder.

Si så at `example.docx` og `node_modules` trygt kan slettes.
