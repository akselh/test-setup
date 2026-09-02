---
name: update-installation-guide
description: >
  Refresh the installation documents of this project when the software gets a
  new version, or when a page they point at changes. Use only when the user says
  "oppdater alle installasjons-guider i prosjektet".
---

# Update the installation guide

## What this does
The installation documents of this project pin exact versions and exact
download links, so a workshop attendee never has to choose. A pin goes stale.
This skill finds the current versions on the internet, verifies every link,
rewrites the pins, and writes a short report of what changed and what a human
must still check by hand — the screenshots above all.

This skill edits files and shows a diff. It never commits. The user reads the
diff and commits.

## The files and their pins
| File | What is pinned there |
| --- | --- |
| `installation-guide.md` | The «sist kontrollert» date at the bottom. No version pin lives here any more. |
| `git-install.md` | The Git for Windows version, in the text and in the example file name `Git-<versjon>-64-bit.exe`. Eight screenshots of the installer. |
| `.claude/skills/pre-workshop-check/SKILL.md` | The GitHub CLI version and both zip links in «The gh install» — the only place the gh version is pinned, because the check installs gh itself. The Node.js version in «The Node.js install», because the check installs Node.js itself too: the Windows zip link, the Mac tarball link, and the folder name `node-v<version>-win-x64` inside the Windows command. This is the only place the Node.js version is pinned. The minimum VS Code version (today 1.131) and the download links in step 7. |
| `check-installation.md`, `github-account.md` | Links only, no versions. |

## Rules
- Verify before you write. A link goes into a file only after a `curl` against
  it answered with HTTP 200. A version goes into a file only after you read it
  from the source named in step 1.
- Never loosen a pin. The guide names exact versions so that every attendee
  installs the same thing. Replace a pin with a newer pin, never with
  «latest».
- Never change the eight recommended choices in `git-install.md`, and never
  change what the workshop requires. When a new installer version renames or
  removes a screen, report it — the decision belongs to the user.
- Never write a customer name, an organisation name, or a value from
  `workshop-info.md` into any of these files. This repository is public.
- The documents stand in Norwegian bokmål. Write new text in bokmål too.
- Report every claim you could not verify. Never guess.

## Step 1 — read the current versions from the sources
Run these. Each one names the source of truth for one program:

```
# Node.js: the first entry with "lts" not false is the current LTS
curl -s https://nodejs.org/dist/index.json | python3 -c "
import json,sys
d=[x for x in json.load(sys.stdin) if x['lts']]
print(d[0]['version'])"

# GitHub CLI
curl -s https://api.github.com/repos/cli/cli/releases/latest | python3 -c "
import json,sys; print(json.load(sys.stdin)['tag_name'])"

# Git for Windows
curl -s https://api.github.com/repos/git-for-windows/git/releases/latest | python3 -c "
import json,sys; print(json.load(sys.stdin)['tag_name'])"
```

Take the Node.js **LTS**, never the newest line. The workshop wants the
version that nodejs.org itself recommends to a normal user.

For VS Code, no pin exists to move — the guide links the download page. Only
the minimum version in the pre-workshop skill can age. Leave it alone unless
the user says the workshop now needs a newer one.

## Step 2 — find the pins in the files
```
grep -rnE 'v?[0-9]+\.[0-9]+\.[0-9]+' installation-guide.md git-install.md .claude/skills/pre-workshop-check/SKILL.md
grep -rnoE 'https?://[^ )>"]+' *.md .claude/skills/*/SKILL.md | sort -u
```

Compare each pin with the version from step 1.

## Step 3 — build and verify the new links
A new version changes the download links. Build them from the patterns the
files already use:

- Node.js, in the pre-workshop skill only:
  `https://nodejs.org/dist/<version>/node-<version>-win-x64.zip`,
  `https://nodejs.org/dist/<version>/node-<version>-darwin-arm64.tar.gz`
  and `https://nodejs.org/dist/<version>/node-<version>-darwin-x64.tar.gz`.
  The Mac link in that file carries `${ARK}` in place of the architecture,
  as the gh link does, so verify it once with `arm64` and once with `x86_64`.
- GitHub CLI:
  `https://github.com/cli/cli/releases/download/v<n>/gh_<n>_windows_amd64.msi`
  and `https://github.com/cli/cli/releases/download/v<n>/gh_<n>_macOS_universal.pkg`
- Git for Windows names its file `Git-<n>-64-bit.exe`, where the tag
  `v2.55.0.windows.5` gives the file version `2.55.0.5`.

Then verify **every** link — the new ones and every old link in every file
from the table above:

```
curl -s -o /dev/null -w "%{http_code} " -I -L --max-time 15 "<lenke>"; echo "<lenke>"
```

A link that answers with anything but 200 goes into the report as broken.
Search the site for the new address, and update the file when you find one
that answers 200. Otherwise leave the file alone and report it.

## Step 4 — write the changes
Update Windows and macOS **together**. A pin exists once per operating
system, and a run that updates one column and forgets the other makes the
guide wrong, which is worse than old.

- Replace the version in every place it stands, also in running text and in
  the example file name in `git-install.md`.
- Set the «sist kontrollert» line at the bottom of `installation-guide.md` to
  today, also when nothing else changed. That line is the proof that somebody
  looked.

## Step 5 — the screenshots and the described pages
You cannot verify a screenshot or a wizard against the internet. Report,
never rewrite:

- Git for Windows got a new version: say in the report that the eight
  screens in `git-install.md` (files `screenshots/git-01` to `git-08`) come
  from the old installer, and that the user should click through the new one
  once and compare. A patch release rarely changes a screen. A new minor
  version often adds one.
- These documents describe pages and dialogs by their exact texts. Fetch the
  pages and compare the texts when you can; report what you could not reach:
  - `github-account.md`: the signup flow.
  - `.claude/skills/pre-workshop-check/SKILL.md`, section «Open a terminal
    for the user», holds the Norwegian text the check relays at login. It
    describes the one question that `gh auth login --hostname github.com --git-protocol https
    --web --clipboard` still asks, «Authenticate Git with your GitHub
    credentials?», and the two lines it prints after that, «One-time code
    (…) copied to clipboard» and «Press Enter to open … in your browser».
    The source of those lines is `internal/authflow/flow.go` in
    github.com/cli/cli. The two screenshots `gh-login-01-terminal.png` and
    `gh-login-02-browser.png` in `screenshots/` are drawings of that
    terminal and of the GitHub page «Authorize your device», with a made-up
    code and user. Their sources stand next to them as `.html` files, and
    headless Chrome renders them: say in the report when a text moved, so
    a human edits the `.html` and renders it again.
  - The download pages: «User Installer» on the VS Code page.

## Step 6 — report
Show `git diff --stat` and a short summary in the chat:

- each pin that moved, old → new
- each link that broke, and what you did about it
- what a human must check by hand (screenshots, wizard screens, page texts
  you could not fetch)
- «Ingen endringer» when everything already stood current — then only the
  date moved.

Do not commit. The user commits after reading the diff.
