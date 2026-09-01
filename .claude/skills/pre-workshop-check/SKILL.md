---
name: pre-workshop-check
description: >
  Check that this machine are setup for the Agentic Edge workshop, and write one
  report the attendee sends to the workshop host. Use when the user says
  "kjør sjekken før workshopen", "sjekk maskinen", "er maskinen klar",
  "pre-workshop-check", "check my machine", or opens this project and asks
  what to do. 
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

## Workshop configuration — read this first
Two values change for each customer: the GitHub organisation and the workshop
repository. They live in `workshop-info.md` in the root of this project. Read
that file before step 4b:

```
cat workshop-info.md
```

Take the value behind **GitHub organisation** and the value behind **Workshop
repository**. Both stand in backticks. This file names no organisation, and
you must never write one into it.

`workshop-info.md` is absent: say so in one Norwegian sentence, skip step 4b,
and write `IKKE TESTET - workshop-info.md mangler` in the three GitHub lines
of the report. Every other step runs as normal.

Below, `<ORG>` means the organisation and `<REPO>` means the repository from
that file. Put the real values in place of them.

## Rules for the whole run
- Install no program. Never edit the user settings of VS Code.
- You can change three things on the machine, each one only after the user says
  yes: the PATH (step 3), the Git identity (step 4) and the Git credential
  helper (step 4b). Every other change is forbidden.
- Never run `gh auth login`, and never run `gh auth logout`. The login is
  interactive and belongs to the user. You read the state, and you report it.
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
command -v gh && gh --version
```

`npm` comes with Node.js. Name it in the report only when `node` works and
`npm` is absent.

`gh` is GitHub CLI. It is absent from the PATH only when it is not installed,
because both installers write to a folder on the PATH. Give the download link
in the report, and go on to step 4b anyway.

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
powershell -NoProfile -Command '$p=[Environment]::GetEnvironmentVariable("Path","User"); if ($p -notlike "*<MAPPE>*") { [Environment]::SetEnvironmentVariable("Path", ($p.TrimEnd(";") + ";<MAPPE>"), "User"); Write-Host "LAGT TIL" } else { Write-Host "ALLEREDE DER" }'
```

Four rules for this command, and each one prevents damage:

- Put the whole command in **single** quotes, and use double quotes inside it.
  The Bash tool expands `$p` and `$env:USERPROFILE` inside double quotes, and
  PowerShell then reads an empty value. Every PowerShell command in this skill
  follows that rule.

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

A PATH fault is rare on a Mac, because the two installers use folders that are
on the PATH already. The `.pkg` of Node.js writes to `/usr/local/bin`, and Git
sits in `/usr/bin`.

Git on a Mac has one fault of its own. `/usr/bin/git` is present on every Mac,
but it is only a stub. The real program arrives with the Command Line Tools of
Xcode. The stub opens a dialog the first time somebody runs it, and
`git --version` then fails or hangs. When you see that:

- Tell the user to click `Install` in the dialog, and to wait for the end of
  the download.
- Tell the user to run the check again after that.
- Write `MANGLER - Command Line Tools ikke installert` in the report.

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

## Step 4b — the GitHub login and the access to the organisation
The workshop clones a repository of the company. This step proves that the
attendee can read it. Skip the whole step when `gh` is absent from the PATH,
and write `MANGLER` in the three report lines.

### 4b.1 Read the login
```
gh auth status
```

The command writes `Logged in to github.com account <navn>` after a good
login. Take the account name for the report.

The command fails with `You are not logged into any GitHub hosts` when the
login is missing. That is a red verdict. Tell the user in Norwegian to run
`gh auth login` in PowerShell or in Terminal, and to answer **Yes** to
«Authenticate Git with your GitHub credentials?». Point at
`installation-guide.md`. Then go on to the next step.

### 4b.2 Test Git against GitHub
The login of `gh` can be good while Git still asks for a password, because the
user answered **No** to «Authenticate Git with your GitHub credentials?». Test
Git itself, and never trust the configuration file alone:

```
GIT_TERMINAL_PROMPT=0 git ls-remote https://github.com/<REPO>; echo "exit=$?"
```

Use the repository from `workshop-info.md`, see the top of this file. The
part `GIT_TERMINAL_PROMPT=0` is a must, and not a detail. Without it Git asks
for a user name, and the command then waits for ever, because you cannot
answer it.

**Judge this test by the exit code, and never by the output.** A repository
with no commits in it answers with `exit=0` and with no text at all. Empty
output is a pass.

- `exit=0`: Git works. Write `OK`.
- The command fails with `could not read Username`: Git has no credentials.
  Write `IKKE SATT OPP`.
- The command fails with `Authentication failed` or `repository not found`:
  Git has no credentials for github.com, or the user has no access. Step 4b.3
  separates the two cases.

The repair for a missing credential helper is one command. It needs no new
login. Ask the user first, in one Norwegian sentence, then run:

```
gh auth setup-git
```

Run `git ls-remote` a second time after that, and write the result of the
second attempt in the report.

For a diagnosis, and never for a verdict, you can read the configuration:

```
git config --get-all credential.https://github.com.helper
git config --get-all credential.helper
```

`!gh auth git-credential` comes from `gh auth setup-git`. A Mac can work with
`osxkeychain` instead, and Windows with `manager`. All three are good when
`git ls-remote` works.

### 4b.3 Read the repository of the organisation
Use the repository from `workshop-info.md`, see the top of this file.

```
gh repo view <REPO> --json name,visibility
```

- The command writes the name: the access is good. Write `OK`.
- The command fails with `Could not resolve to a Repository`: the user is not
  a member of the organisation, or the invitation is still open. GitHub hides
  a private repository from a user without access, so the error names no
  organisation. Write `INGEN TILGANG` in the report, and tell the user to look
  for the invitation e-mail from GitHub, and to contact the coordinator when
  the e-mail is absent.
- The command fails with another text: write that text in the report.

Read nothing else, and clone nothing. The check only reads.

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

### 5b. The proxy certificate
Do this part only when `npm install` failed with one of these texts:

- `SELF_SIGNED_CERT_IN_CHAIN`
- `unable to get local issuer certificate`
- `UNABLE_TO_GET_ISSUER_CERT_LOCALLY`

The cause is always the same. A proxy of the company opens the traffic and signs
it again with a certificate of the company. Windows trusts that certificate.
Node.js does not, because Node.js carries its own list of certificates.

The repair takes the certificates out of Windows and gives them to Node.js. It
needs no admin rights, and it removes the IT ticket.

**1. Ask the user.** Ask in one Norwegian sentence for permission to point
npm at the certificates of Windows. Wait for the answer.

**2. Write the certificates to one file.** This command reads the root
store of Windows and writes every certificate as one PEM file:

```
powershell -NoProfile -Command '$out=Join-Path $env:USERPROFILE "windows-root-ca.pem"; Get-ChildItem Cert:\LocalMachine\Root | ForEach-Object { "-----BEGIN CERTIFICATE-----"; [Convert]::ToBase64String($_.RawData,"InsertLineBreaks"); "-----END CERTIFICATE-----" } | Set-Content -Encoding ascii $out; Write-Host $out'
```

Take every certificate, and never search for the name of a proxy vendor. Two
reasons:

- The file replaces the list of npm. A file with one certificate breaks every
  other address. The full root store of Windows holds the public certificates
  as well, so the list stays complete.
- This repository is public. A vendor name in the code names the customer.

**3. Point npm at the file.** `.npmrc` takes effect at once, so this
repairs the run you are in:

```
npm config set cafile "<stien som kommando 2 skrev ut>"
```

**4. Repair Node.js for later runs too.** The variable reaches only a
program that starts after the change, so it does nothing for this run:

```
powershell -NoProfile -Command '[Environment]::SetEnvironmentVariable("NODE_EXTRA_CA_CERTS", (Join-Path $env:USERPROFILE "windows-root-ca.pem"), "User")'
```

**5. Make the Word file again.** Start the `docx` skill a second time with the
same task. Write the result of that second attempt in the report.

Never run `npm config set strict-ssl false`. It hides the fault, and it turns
off the certificate check for every address. Refuse it, also when the user asks
for it.

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
Navn:           <navn, eller "ikke oppgitt">
Operativsystem: <operativsystem>
Dato:           <dato>

RESULTAT:    MASKINEN ER KLAR FOR WORKSHOP
             (eller: MASKINEN MANGLER: <kort liste>)

Git-identitet: SATT av <navn> <e-post>
             (eller: SATT AV SJEKKEN / IKKE SATT)
GitHub-bruker: <brukernavn GitHub> 
             (eller: IKKE FUNNET)

Installasjoner:
Node.js:     <versjon>
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH)
npm:         <versjon>   (eller: MANGLER)
Git:         <versjon>
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH)
VS Code:     <versjon>   (eller: MANGLER / FOR GAMMEL, krever 1.131)
GitHub CLI:  <versjon>   (eller: MANGLER)

Tester:
GitHub-innlogging: OK - logget inn som <kontonavn>
             (eller: IKKE LOGGET INN / MANGLER)
Org-tilgang: OK - leste <REPO>
             (eller: INGEN TILGANG / IKKE TESTET)
Git mot GitHub: OK - git ls-remote leste repoet
             (eller: IKKE SATT OPP / SATT OPP AV SJEKKEN / IKKE TESTET)
Word-test:   OK - word-example.docx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)
PowerPoint:  OK - powerpoint-example.pptx, <n> byte
             (eller: FEILET - <den eksakte feilmeldingen>)

PATH-reparasjon: <hva sjekken la til, eller "ikke nødvendig">
Proxy-sertifikat: <"ikke nødvendig", eller "reparert, npm cafile satt">

Dette må fikses:
<én linje per mangel, med lenke. Skriv "Ingenting." når alt er OK.>
=== SLUTT ===
```

Then write the same text to the file `pre-workshop-check-<navn>.md` in the root
of this project. Use the name of the user in the file name, in lower case and
without spaces. Write "ukjent" when the user gave no name.

Rules for the report:

- The verdict line is green only when Node.js, npm, Git, VS Code, GitHub CLI,
  the GitHub login, the access to the organisation, the Word test and the
  PowerPoint test are all OK.
- `PÅ DISK, MEN IKKE PÅ PATH` is red, not green.
- Give the link for each program that is absent:
  - Node.js: https://nodejs.org/en/download
  - Git on Windows: https://git-scm.com/install/windows, and the guide
    `git-install.md` in this folder
  - Git on a Mac: the command `git --version` in Terminal starts the install
  - VS Code: https://code.visualstudio.com/download
  - GitHub CLI: https://cli.github.com/, and the guide `installation-guide.md`
    in this folder
  - The GitHub login: the command `gh auth login`, and `installation-guide.md`
- Two faults need the workshop coordinator, not IT, and the report must say so:
  - a login that works, but no access to the organisation. The coordinator
    sends the invitation.
  - an attendee with no GitHub account at all.
- Three faults need IT, and the report must say so:
  - a VS Code that the company controls and holds on an old version
  - a PATH that the company controls with a group policy, so the repair in
    step 3 does not survive a restart
  - a proxy that blocks the npm registry **and** survives the repair in step
    5b. The repair in 5b solves the normal case without IT. Name IT only when
    the second attempt fails as well, and give the error text of that attempt.
- Never guess a cause. Write the error text that you saw.

## After the report
Tell the user in one Norwegian sentence to send the file
`pre-workshop-check-<navn>.md` to the workshop host.

Then say that `word-example.docx`, `powerpoint-example.pptx` and `node_modules`
are safe to delete.
