---
name: pre-workshop-check
description: >
  Check that this machine is set up for the Agentic Edge workshop, and write one
  report the attendee sends to the workshop host. Use when the user says
  "kjør sjekken før workshopen", "sjekk maskinen", "er maskinen klar",
  "pre-workshop-check", "check my machine", or opens this project and asks
  what to do. 
---

# Pre-workshop check

## What this does
This skill answers one question: can this machine run the workshop?

It answers with real tests, not with a list of installed programs. First it
reads the programs that the workshop needs. Then it proves the GitHub access
by cloning the workshop repository of the company, so the attendee arrives
with the code in place. Last it makes a Word file from `word-example.md` and
a PowerPoint file from `powerpoint-example.md`. The machine can do the work
when the clone and both files appear.

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
repository**. Both stand in backticks. This skill file (`SKILL.md`) names no
organisation, and you must never write a customer name into it — the name
lives in `workshop-info.md` only.

`workshop-info.md` is absent: say so in one Norwegian sentence, skip step 4b,
and write `IKKE TESTET - workshop-info.md mangler` in the four GitHub lines
of the report. Every other step runs as normal.

Below, `<ORG>` means the organisation and `<REPO>` means the repository from
that file. Put the real values in place of them.

## Rules for the whole run
- Install no program yourself, and never download an installer. When a program
  is missing, the **user** installs it, and you wait — see «The install
  offer» below. One exception exists: GitHub CLI, which you can install into
  the home folder after a yes — see «The gh install». Never edit the user
  settings of VS Code.
- Repair every fault you can repair before you write the report. The report
  describes the machine as it stands at the end of the run, not as it stood at
  the start.
- You can change three things on the machine, each one only after the user says
  yes: the PATH (step 3), the Git identity (step 4) and the Git credential
  helper (step 4b). Every other change is forbidden.
- Never run `gh auth login`, and never run `gh auth logout`. The login is
  interactive and belongs to the user. You read the state, you can ask the
  user to log in in their own terminal and wait (step 4b.1), and you report
  the state at the end.
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

One exception exists, for `gh` alone, after the check itself installed it —
«The gh install» below names it and the reasons.

## The install offer — when a program is not installed
A program that is absent from the PATH **and** absent from the disk is not
installed. Do not park that fault in the report and move on. The user sits at
the machine now, and an install takes two minutes. So:

1. Tell the user in Norwegian which program is missing. Give the download
   link from the list in step 7, and name the right installer for the
   operating system — `installation-guide.md` holds that detail.
2. Ask whether the user wants to install it now. Wait for the answer.
3. The user says no: write `MANGLER` in the report, with the link, and go on
   to the next step.
4. The user says the install is done: run the PATH lookup from step 2 again.
   - The program answers: write the version in the report, with the note
     `installert under sjekken`. Run the steps that you skipped because the
     program was missing.
   - The program is still absent from the PATH, but sits on the disk now: the
     install worked, and this running program holds the old PATH. Tell the
     user to close Claude Desktop completely, open it again, and run the
     check once more. Write `INSTALLERT UNDER SJEKKEN - krever omstart av
     Claude Desktop` in the report.

The offer covers Node.js, Git and VS Code, in step 2 and in step 3b. Those
three need a real installer, and only the user runs installers. GitHub CLI
has its own way — see the next section. For the three above you never
download an installer, and you never run one. That rule holds also when the
user asks you to.

## The gh install — the one program you install yourself
GitHub CLI is different from the other programs: it is one self-contained
binary, the official release ships it as a plain zip, and it can live in the
home folder without administrator rights. So when `gh` is missing, you do
not send the user to an installer — you offer to do it, and after a yes you
do it.

Ask the user in one Norwegian sentence for permission to install GitHub CLI
into the home folder. Wait for the answer. After a no: write `MANGLER` in
the report, with the link, and go on.

After a yes, on a Mac:

```
ARK=$(uname -m | sed 's/x86_64/amd64/')
curl -sL "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_macOS_${ARK}.zip" -o /tmp/gh.zip
unzip -oq /tmp/gh.zip -d /tmp
mkdir -p ~/.local/bin
cp "/tmp/gh_2.98.0_macOS_${ARK}/bin/gh" ~/.local/bin/
grep -q '.local/bin' ~/.zprofile 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile
~/.local/bin/gh --version
```

On Windows (the quoting rule from step 3c holds here too):

```
powershell -NoProfile -Command 'curl.exe -sL "https://github.com/cli/cli/releases/download/v2.98.0/gh_2.98.0_windows_amd64.zip" -o "$env:TEMP\gh.zip"; Expand-Archive "$env:TEMP\gh.zip" -DestinationPath "$env:LOCALAPPDATA\Programs\gh" -Force; $p=[Environment]::GetEnvironmentVariable("Path","User"); $b="$env:LOCALAPPDATA\Programs\gh\bin"; if ($p -notlike "*$b*") { [Environment]::SetEnvironmentVariable("Path", ($p.TrimEnd(";") + ";" + $b), "User") }; & "$env:LOCALAPPDATA\Programs\gh\bin\gh.exe" --version'
```

The last line prints the version: the install worked. Write `INSTALLERT
UNDER SJEKKEN` in the report, with the version. Download from the address
above and from nowhere else — it is the official release of GitHub CLI.

For the rest of this run, call the new `gh` through its full path —
`~/.local/bin/gh` on a Mac, `$LOCALAPPDATA/Programs/gh/bin/gh.exe` on
Windows. This breaks the rule of the masking trap on purpose, and it is safe
for `gh` alone, for two reasons:

- The install above put the folder on the PATH of every **new** terminal and
  of the next start of Claude Desktop. Only this running process misses it.
- The workshop itself does not need `gh` on the PATH. Git reaches `gh`
  through the credential helper, and `gh auth setup-git` writes the **full
  path** of the binary into the Git configuration. Prove that in step 4b.2:
  run the repair through the full path, then read
  `git config --get-all credential.https://github.com.helper` and see that
  the helper names the home folder. The helper names another gh, or none:
  that is a failure — report it.

The login stays with the user. Offer to open the terminal window for the
user — see «Open a terminal for the user» below. The user opens one
themselves instead: the window must be **new** — opened after the install,
so it has the new PATH — and when that terminal does not know `gh`, give
the user the full path to run.

## Open a terminal for the user
Two moments send the user to their own terminal for `gh auth login`: right
after «The gh install», and in step 4b.1. You can open that terminal window
yourself. Offer it in the same Norwegian sentence that asks for the login,
and wait for the answer.

With the offer, show the user what to answer in the terminal: read the
section «Innlogging på GitHub» in `check-installation.md` and repeat its
answers in the chat. That section is the source of the answers — relay it,
and never write a list of your own.

After a yes, on a Mac:

```
osascript -e 'tell application "Terminal" to do script "gh auth login"' -e 'tell application "Terminal" to activate'
```

On Windows:

```
powershell -NoProfile -Command 'Start-Process powershell -ArgumentList "-NoExit","-Command","gh auth login"'
```

When the check itself installed `gh` in this run, replace `gh auth login`
with the full path:

- Mac: `~/.local/bin/gh auth login`. The new Terminal window runs a login
  shell and reads `.zprofile`, so bare `gh` works there too — but the full
  path works always.
- Windows: a window from `Start-Process` inherits the PATH of **this**
  process, not the repaired user PATH, so bare `gh` fails there. Use:

  ```
  powershell -NoProfile -Command 'Start-Process powershell -ArgumentList "-NoExit","-Command","& `"$env:LOCALAPPDATA\Programs\gh\bin\gh.exe`" auth login"'
  ```

Two rules for this window:

- On a Mac the first `osascript` call can open a macOS permission dialog
  («Claude» wants to control «Terminal»). The user clicks *Ikke tillat*, or
  the command fails: do not retry. Tell the user to open a terminal
  themselves, and give the exact command to run.
- The window belongs to the user. You never read it, and you never type in
  it. Ask the user to say when the login is done, and wait — see step 4b.1
  for what happens next.

The login state lands on the disk the moment `gh auth login` finishes.
Every command you run starts a fresh process that reads that state again.
So the login needs **no** restart of Claude Desktop — only a PATH change
needs that.

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

`gh` is GitHub CLI. The check installs it into the home folder when it is
missing — see «The gh install» — and an earlier run can have done the same.
So when `gh` is absent from the PATH, look at these two places first:

- Mac: `~/.local/bin/gh`
- Windows: `$LOCALAPPDATA/Programs/gh/bin/gh.exe`

The file sits there: the PATH is the fault. Write `PÅ DISK, MEN IKKE PÅ PATH`
in the report, and tell the user to restart as the guide says — on a Mac
close Claude completely and open it again, on Windows log out and in. The
file is absent there too: offer to install it — see «The gh install» above.
Go on to step 4b in every case.

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

VS Code is absent from the PATH **and** absent from those disk places: make
the install offer (see above). After the install, look at the disk places
again — that lookup needs no restart, so the verdict can turn green in this
run.

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
  program is not installed. Make the install offer (see above). Then go on to
  the next step.
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
attendee can read it, and ends with the clone itself. `gh` is absent from
the PATH **and** the check did not install it: skip 4b.1 and 4b.3, and
write `MANGLER` in their report lines — but run 4b.2 and 4b.4 anyway,
because both work with `git` alone, and they can still pass. The check
installed `gh` in this run: run every part of 4b, and call `gh` through
its full path — see «The gh install».

### 4b.1 Read the login
```
gh auth status
```

The command writes `Logged in to github.com account <navn>` after a good
login. Take the account name for the report.

The command fails with `You are not logged into any GitHub hosts` when the
login is missing. Do not go straight to the report — the user can repair this
now, in the middle of the run. Offer to open a terminal window with
`gh auth login` for the user — see «Open a terminal for the user» above.
The user declines, or the window does not open: tell the user in Norwegian
to open PowerShell or Terminal **next to Claude** and run `gh auth login`
there. In both cases the user must answer **Yes** to «Authenticate Git with
your GitHub credentials?». Point at the section «Innlogging på GitHub» in
`check-installation.md`. Ask the user to say when the login is done, and
wait.

The user says done: run `gh auth status` again, and continue with the result
of the second attempt. The new login works at once in this session, and no
restart of Claude Desktop is needed — see «Open a terminal for the user».
Write `logget inn under sjekken` in the report.

The user says no, or the login fails: that is a red verdict. Write it in the
report, and go on to the next step.

You never run `gh auth login` yourself — the login is interactive, and only
the user can answer it.

### 4b.2 Test Git against GitHub
The login of `gh` can be good while Git still asks for a password, because the
user answered **No** to «Authenticate Git with your GitHub credentials?». Test
Git itself, and never trust the configuration file alone. This is the one
test where bare `git` is deliberate: the workshop runs `git clone` and
`git push`, and a `gh` command here would pass on the login of `gh` even when
Git itself has no credentials. Never replace this command with `gh`:

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
login. The repair needs `gh`: when `gh` is missing from both the PATH and
the disk, skip the repair, write the verdict of the first attempt, and go
on. Otherwise ask the user first, in one Norwegian sentence, then run:

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

Read nothing else in the organisation. Step 4b.4 clones the workshop
repository, and nothing else.

### 4b.4 Clone the workshop repository
The workshop starts with the repository on the disk. Clone it now. That
proves the whole chain — Git, the credentials and the access — in the one
command the workshop itself will need, and the attendee arrives with the
code in place.

Skip this step, and write `IKKE TESTET` in the report, when `git` is absent
from the PATH, or when step 4b.3 ended in `INGEN TILGANG`.

Clone with `gh`, and with bare `git` only when `gh` is absent from the PATH.
`gh` carries its own login, so the clone succeeds also on a machine where
Git waits for a repair. The clone through `gh` therefore proves the access
and nothing more — so right after a fresh clone, run one `git pull` inside
it. The workshop day starts with exactly that command, in exactly that
folder, and the pull uses the credentials of Git, not of `gh`. The verdict
of the line «Git mot GitHub» still comes from step 4b.2 alone; the pull here
is the confirmation in the real folder.

The target folder sits **next to** this project folder, and carries the name
of the repository. `<NAVN>` below means the part of `<REPO>` behind the
slash. The project sits in `~/dev/workshop-setup-test`, so the clone lands in
`~/dev/<NAVN>`.

Look at the target first:

- The folder `../<NAVN>` is absent: clone.

  ```
  gh repo clone <REPO> ../<NAVN>; echo "exit=$?"
  ```

  `gh` is absent from the PATH — use bare Git instead:

  ```
  GIT_TERMINAL_PROMPT=0 git clone https://github.com/<REPO> ../<NAVN>; echo "exit=$?"
  ```

  `exit=0` on the clone: run the pull inside the fresh clone.

  ```
  GIT_TERMINAL_PROMPT=0 git -C ../<NAVN> pull; echo "exit=$?"
  ```

  The pull answers `exit=0`: write `OK`, with the full path of the new
  folder, and the note `git pull virker`. A warning about an empty
  repository is still a pass. The clone or the pull fails: keep the exact
  error text, and write `FEILET - <teksten>`. A pull that fails after a good
  clone points at the credentials of Git — look at the result of step 4b.2
  before you name a cause.

- The folder `../<NAVN>` exists: never clone over it, and never delete it.
  Read where it points:

  ```
  git -C ../<NAVN> remote get-url origin
  ```

  The answer names `<REPO>`: write `ALLEREDE KLONET`, and that is a pass.
  Any other answer, or no git repository at all: write `FEILET - mappen
  <full sti> er i veien`, and touch nothing.

The pull belongs to a fresh clone only. In a folder that existed before this
run, never pull, and never change a file — the folder can hold the work of
the attendee. Tell the user in one Norwegian sentence where the folder
landed, and that the workshop uses it.

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
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH
              / INSTALLERT UNDER SJEKKEN - krever omstart av Claude Desktop)
npm:         <versjon>   (eller: MANGLER)
Git:         <versjon>
             (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH
              / INSTALLERT UNDER SJEKKEN - krever omstart av Claude Desktop)
VS Code:     <versjon>   (eller: MANGLER / FOR GAMMEL, krever 1.131)
GitHub CLI:  <versjon>   (eller: MANGLER / PÅ DISK, MEN IKKE PÅ PATH
                          / INSTALLERT UNDER SJEKKEN)

Tester:
GitHub-innlogging: OK - logget inn som <kontonavn>
             (eller: IKKE LOGGET INN / MANGLER)
Org-tilgang: OK - leste <REPO>
             (eller: INGEN TILGANG / IKKE TESTET)
Git mot GitHub: OK - git ls-remote leste repoet
             (eller: IKKE SATT OPP / SATT OPP AV SJEKKEN / IKKE TESTET)
Workshop-repo klone-test:  OK - klonet <REPO> til <full sti>, git pull virker
             (eller: ALLEREDE KLONET / FEILET - <feilmeldingen> / IKKE TESTET)
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
  the GitHub login, the access to the organisation, the clone of the workshop
  repository, the Word test and the PowerPoint test are all OK.
  `ALLEREDE KLONET` counts as OK.
- `PÅ DISK, MEN IKKE PÅ PATH` is red, not green.
- A program that the user installed during the check counts green when the
  PATH lookup answers, and red when the verdict waits for a restart of
  Claude Desktop. A repair in this run makes the verdict green only when the
  test behind it passed in this run.
- A red verdict that only needs a restart is a small fault. Say in the report,
  and to the user, that one restart of Claude Desktop and one new run of the
  check is the whole repair.
- Give the link for each program that is absent:
  - Node.js: https://nodejs.org/en/download
  - Git on Windows: https://git-scm.com/install/windows, and the guide
    `git-install.md` in this folder
  - Git on a Mac: the command `git --version` in Terminal starts the install
  - VS Code: https://code.visualstudio.com/download
  - GitHub CLI: the check installs it — write that a new run of the check
    installs it after a yes, or point at https://cli.github.com/
  - The GitHub login: the command `gh auth login`, and the section
    «Innlogging på GitHub» in `check-installation.md`
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
are safe to delete — but that the cloned workshop folder next to this project
stays, because the workshop uses it.
