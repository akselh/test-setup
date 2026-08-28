---
name: pre-workshop-check
description: >
  Check that this machine can run the Agentic Edge workshop, and write one
  report the attendee sends to the workshop host. Use when the user says
  "kjør sjekken før workshopen", "sjekk maskinen", "er maskinen klar",
  "pre-workshop-check", "check my machine", or opens this project and asks
  what to do. The check reads Node.js, Git and VS Code, repairs the PATH when
  a program is on disk but absent from the PATH, sets the Git identity, and
  then makes a real Word file and a real PowerPoint file.
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
- Install no program. Never edit the user settings of VS Code.
- You can change one thing on the machine, and only after the user says yes:
  the PATH (step 3) and the Git identity (step 4). Every other change is
  forbidden.
- Run every step, also after a failure. The report needs the full picture.
- Keep the exact error text of a step that failed. Never guess a cause.
- Write the report in Norwegian, and write it last.

## The masking trap — read this before step 2
A program that sits on the disk but is absent from the PATH is a **failure**,
not a pass. Claude Code can find `node.exe` on the disk and call it with the
full path. The check then looks green, and the workshop breaks on the first
day.

So:

- Decide every verdict with a PATH lookup, and with nothing else.
- Never call `node`, `npm` or `git` through a full path to make a test pass.
- Never give a full path to the `docx` skill or to the `pptx` skill.
- A full path is a diagnosis tool in step 3 only. It never changes a verdict.

## Step 1 — say what you do
Say in one Norwegian sentence that you start the check. Then run. Ask no
question here. The user asked for the check already.

## Step 2 — read the programs on the PATH
Run these commands. Each one can fail. A failure is a result, not a stop.

```
command -v node && node --version
command -v npm && npm --version
command -v git && git --version
command -v code && code --version
```

`npm` comes with Node.js. Name it in the report only when `node` works and
`npm` is absent.

`code` is a special case. The installer of VS Code adds it to the PATH only
when the user ticked the box. A `code` that is absent from the PATH does not
break the workshop. Look for the program file, and report the version:

- Windows: `$LOCALAPPDATA/Programs/Microsoft VS Code/bin/code.cmd`, then
  `/c/Program Files/Microsoft VS Code/bin/code.cmd`
- Mac: `/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code`

The first line of the output is the version number. The workshop needs version
1.131 or newer, because of the hybrid markdown editor. The file
`.vscode/settings.json` in this folder turns that editor on for everybody, so
no user has to change a setting.

## Step 3 — repair the PATH
Do this step for `node` and for `git` only. Skip it when both are on the PATH.

### 3a. Find the program on the disk
Look in these places:

Node.js on Windows:

```
ls "/c/Program Files/nodejs/node.exe"
ls "/c/Program Files (x86)/nodejs/node.exe"
ls "$LOCALAPPDATA/Programs/nodejs/node.exe"
```

Git on Windows:

```
ls "/c/Program Files/Git/cmd/git.exe"
ls "/c/Program Files/Git/bin/git.exe"
```

On a Mac, look in `/usr/local/bin`, `/opt/homebrew/bin` and
`/usr/local/opt/node/bin`.

### 3b. Name the fault
- The program is absent from the PATH **and** absent from the disk: the
  program is not installed. Give the download link in the report. Go on to the
  next step.
- The program is absent from the PATH **and** present on the disk: the PATH is
  the fault. Continue with 3c.

### 3c. Ask, then repair (Windows)
Ask the user in one Norwegian sentence for permission to add the folder to the
PATH. Wait for the answer. Do nothing when the user says no.

After a yes, run this command. Put the real folder of the program in place of
`<MAPPE>`, for example `C:\Program Files\nodejs`:

```
powershell -NoProfile -Command "$p=[Environment]::GetEnvironmentVariable('Path','User'); if ($p -notlike '*<MAPPE>*') { [Environment]::SetEnvironmentVariable('Path', ($p.TrimEnd(';') + ';<MAPPE>'), 'User'); Write-Host 'LAGT TIL' } else { Write-Host 'ALLEREDE DER' }"
```

Three rules for this command, and each one prevents damage:

- Read `'Path'` from the scope `'User'`. Never read `$env:Path`. `$env:Path`
  holds the system PATH as well, and a write of that value into the user PATH
  makes a copy that breaks on the next update of the machine.
- Never use `setx`. It cuts the value at 1024 characters without a warning.
- Write to the scope `'User'`. The scope `'Machine'` needs admin rights, and
  the workshop attendee does not have them.

### 3d. Say what happens next
The repair does not reach the running program. Say this to the user, in
Norwegian:

- Close Claude Desktop completely, and open it again. Then run the check once
  more.
- The PATH still fails after that: restart the machine. Windows gives the new
  PATH to a program only when the program starts after the change, and
  Claude Desktop takes its PATH from the process that started it.

Mark the program as `MANGLER PÅ PATH` in the report of this run. A repair in
this run cannot make the verdict green. The next run decides that.

### 3e. On a Mac
Report the fault. Do not repair it. A GUI program on a Mac takes its PATH from
`launchd`, not from the shell profile, so an edit of `.zshrc` does not help
Claude Desktop.

## Step 4 — the Git identity
Git refuses to save a change before it knows a name and an e-mail address.
Read the two values:

```
git config --global user.name
git config --global user.email
```

Both values are present: write `SATT` in the report, and go on.

One value is empty: ask the user for the name and the e-mail address, in one
Norwegian sentence. Then set the value that is missing:

```
git config --global user.name "<navn>"
git config --global user.email "<e-post>"
```

Write in the report that the check set the value.

Skip this step when `git` is absent from the PATH.

## Step 5 — make the Word file
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

## Step 6 — make the PowerPoint file
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

## Step 7 — write the report
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

Node.js:     <versjon>
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH)
npm:         <versjon>   (eller: MANGLER)
Git:         <versjon>
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH)
Git-identitet: SATT av <navn> <e-post>
             (eller: SATT AV SJEKKEN / IKKE SATT)
VS Code:     <versjon>   (eller: MANGLER / FOR GAMMEL, krever 1.131)
Word-test:   OK - word-example.docx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)
PowerPoint:  OK - powerpoint-example.pptx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)

PATH-reparasjon: <hva sjekken la til, eller "ikke nødvendig">

Dette må fikses:
<én linje per mangel, med lenke. Skriv "Ingenting." når alt er OK.>
=== SLUTT ===
```

Then write the same text to the file `pre-workshop-check-<navn>.md` in the root
of this project. Use the name of the user in the file name, in lower case and
without spaces. Write "ukjent" when the user gave no name.

Rules for the report:

- The verdict line is green only when Node.js, npm, Git, VS Code, the Word test
  and the PowerPoint test are all OK.
- `PÅ DISK, MEN IKKE PÅ PATH` is red, not green.
- Give the link for each program that is absent:
  - Node.js: https://nodejs.org/en/download
  - Git: https://git-scm.com/download/win, and the guide `git-install.md` in
    this folder
  - VS Code: https://code.visualstudio.com/download
- Three faults need IT, and the report must say so:
  - a VS Code that the company controls and holds on an old version
  - a PATH that the company controls with a group policy, so the repair in
    step 3 does not survive a restart
  - a proxy that blocks the npm registry. You see it when `npm install` fails
    with `SELF_SIGNED_CERT_IN_CHAIN` or `unable to get local issuer
    certificate`. IT must add the certificate of the proxy to npm.
- Never guess a cause. Write the error text that you saw.

## After the report
Tell the user in one Norwegian sentence to send the file
`pre-workshop-check-<navn>.md` to the workshop host.

Then say that `word-example.docx`, `powerpoint-example.pptx` and `node_modules`
are safe to delete.
