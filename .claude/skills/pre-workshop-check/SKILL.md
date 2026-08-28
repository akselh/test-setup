---
name: pre-workshop-check
description: >
  Check that this machine can run the Agentic Edge workshop, and write one
  report the attendee sends to the workshop host. Use when the user says
  "kjør sjekken før workshopen", "sjekk maskinen", "er maskinen klar",
  "pre-workshop-check", "check my machine", or opens this project and asks
  what to do. The check reads Node.js, VS Code and Git, and then makes a real
  Word file and a real PowerPoint file.
---

# Pre-workshop check

## What this does
This skill answers one question: can this machine run the workshop?

It answers with real tests, not with a list of installed programs. First it
reads the three programs that the workshop needs. Then it makes a Word file
from `word-example.md` and a PowerPoint file from `powerpoint-example.md`. The
machine can do the work when both files appear.

The result is one short report in Norwegian. The skill shows the report in the
chat and writes it to a file. The attendee sends that file to the workshop
host.

## Rules for the whole run
- Change nothing on the machine. Install no program. Never edit the user
  settings of VS Code.
- Run every step, also after a failure. The report needs the full picture.
- Keep the exact error text of a step that failed. Never guess a cause.
- Write the report in Norwegian, and write it last.

## Step 1 — say what you do
Say in one Norwegian sentence that you start the check. Then run. Ask no
question here. The user asked for the check already.

## Step 2 — read the three programs
Run these commands. Each one can fail. A failure is a result, not a stop.

```
node --version
npm --version
git --version
code --version
```

`npm` comes with Node.js. Name it in the report only when `node` works and
`npm` is absent.

The `code` command is on PATH only when the installer added it. When
`code --version` fails, look for the program file:

- Windows: `$LOCALAPPDATA/Programs/Microsoft VS Code/bin/code.cmd`, then
  `/c/Program Files/Microsoft VS Code/bin/code.cmd`
- Mac: `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`

The first line of the output is the version number. The workshop needs version
1.132 or newer, because of the hybrid markdown editor. The file
`.vscode/settings.json` in this folder turns that editor on for everybody, so
no user has to change a setting.

## Step 3 — make the Word file
Use the `docx` skill from Anthropic. Claude Desktop supplies it. It shows in
the skill list as `docx`, or as `anthropic-skills:docx`. Start it with the
`Skill` tool. Do not copy that skill, and do not write the Word file with your
own code.

Give the skill this task:

- source: `word-example.md` in this folder
- output: `word-example.docx` in this folder
- the document is Norwegian
- every heading, table and list must survive

The skill runs `npm install docx` first, because the package is absent on a
normal machine. That step needs the npm registry. It is the step that fails
most often on a machine that a company controls.

Check the result. The test passes when the file exists and is larger than zero
bytes:

```
ls -l word-example.docx
```

## Step 4 — make the PowerPoint file
Use the `pptx` skill from Anthropic in the same way. It shows as `pptx`, or as
`anthropic-skills:pptx`.

Give the skill this task:

- source: `powerpoint-example.md` in this folder
- output: `powerpoint-example.pptx` in this folder
- one slide for each `##` heading, Norwegian text
- keep the bullet lists and the table

Check the result:

```
ls -l powerpoint-example.pptx
```

## Step 5 — write the report
Ask the user for the name in one Norwegian sentence, when you do not know it.
Then write the report.

Show the report in the chat inside one code block, so the user can copy it in
one action. Use this form exactly:

```
=== RAPPORT TIL WORKSHOP-KOORDINATOR ===
Navn:        <navn, eller "ikke oppgitt">
Maskin:      <maskinnavn og operativsystem>
Dato:        <dato>

RESULTAT:    MASKINEN ER KLAR FOR WORKSHOP
             (eller: MASKINEN MANGLER: <kort liste>)

Node.js:     <versjon>   (eller: MANGLER)
Git:         <versjon>   (eller: MANGLER)
VS Code:     <versjon>   (eller: MANGLER / FOR GAMMEL, krever 1.131)
Word-test:   OK - word-example.docx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)
PowerPoint:  OK - powerpoint-example.pptx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)

Dette må fikses:
<én linje per mangel, med lenke. Skriv "Ingenting." når alt er OK.>
=== SLUTT ===
```

Then write the same text to the file `pre-workshop-check-<navn>.md` in the root
of this project. Use the name of the user in the file name, in lower case and
without spaces. Write "ukjent" when the user gave no name.

Rules for the report:

- The verdict line is green only when all five lines above it are OK.
- Give the link for each program that is absent:
  - Node.js: https://nodejs.org/en/download
  - Git: https://git-scm.com/downloads
  - VS Code: https://code.visualstudio.com/download
- Two faults need IT, and the report must say so:
  - a VS Code that the company controls and holds on an old version
  - a proxy that blocks the npm registry. You see it when `npm install` fails
    with `SELF_SIGNED_CERT_IN_CHAIN` or `unable to get local issuer
    certificate`. IT must add the certificate of the proxy to npm.
- Never guess a cause. Write the error text that you saw.

## After the report
Tell the user in one Norwegian sentence to send the file
`pre-workshop-check-<navn>.md` to the workshop host.

Then say that `word-example.docx`, `powerpoint-example.pptx` and `node_modules`
are safe to delete.
