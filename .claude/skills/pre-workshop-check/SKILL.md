---
name: pre-workshop-check
description: >
  Check that this machine can run the Agentic Edge workshop, and write one
  report the attendee sends to the workshop host. Use when the user says
  "kjør sjekken før workshopen", "sjekk maskinen", "er maskinen klar",
  "pre-workshop-check", "check my machine", or opens this project and asks
  what to do.
  The test that decides the verdict is a real Word export of `example.md`.
---

# Pre-workshop check

## What this does
This skill answers one question: can this machine run the workshop?

It answers with a real test, not with a list of installed programs. It
makes a Word file from `example.md`. If the Word file appears, the machine
can do the work. If it does not, the skill finds out why.

The result is one report. The attendee copies the report and sends it to
the workshop host.

## When to use it
Use it when the user asks for the check, or asks if the machine is ready.
`guide.md` tells the user to ask for it.

The file `KJOR-DENNE.md` in the root holds the same steps, in Norwegian.
It is there for the session that cloned this repo while it ran, because
that session never loaded this skill. Keep the two files the same. A change
here needs the same change there.

## The two tests

**Test 1: the Word export.** This decides the verdict. It uses the `docx`
skill from Anthropic, which Claude Desktop supplies. Do not copy that
skill. Call it where it is.

**Test 2: VS Code.** The workshop uses the hybrid markdown editor. It needs
version 1.131 or newer. The editor is on by default. The file
`.vscode/settings.json` in this folder sets it for everybody, so no user
has to change a setting.

Both tests must pass for a green verdict.

## Steps

1. **Say what you are about to do**, in Norwegian, in one sentence. Then
   run. Ask no question. The user asked once, in `guide.md`.

2. **Run the Word export.** Find the `docx` skill in the skill list of the
   session. It shows as `docx`, or as `anthropic-skills:docx`. Start it
   with the `Skill` tool. Give it `example.md`, and the output path
   `example.docx`, in this folder. State that the document is Norwegian,
   and that every heading, table and list must survive.

   Note what happens. The skill runs `npm install docx` first, because the
   package is absent on a normal machine. That step needs the npm
   registry. It is the step that fails most often.

3. **Check the result.** The test passes when `example.docx` exists and is
   larger than zero bytes:

   ```
   ls -l example.docx
   ```

   Keep the exact error text if the test failed. The report needs it.

4. **Run the diagnose script.** Run it always, not only after a failure.
   It reads VS Code, and it explains a failed export.

   ```
   powershell -ExecutionPolicy Bypass -File .\.claude\skills\pre-workshop-check\preflight-check.ps1
   ```

   On a Mac, run `bash` equivalents of the same four checks, and say in the
   report that the machine is a Mac.

5. **Write the report.** Follow "The report" below, word for word.

6. **Change nothing on the machine.** Install no program. Never edit the
   user settings of VS Code. The file `.vscode/settings.json` in this
   folder does that work, and it stays inside this folder. This skill
   reports. It does not repair. Name the fix in the report, and let the
   user choose.

## The report

Write the report last, in Norwegian, inside one code block, so the user can
copy it in one action. Use this form exactly:

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

Rules for the report:
- The verdict line is green only when the Word test passed **and** VS Code
  is 1.131 or newer. Nothing else can make it red.
- Name the fix the user can do, and the fix that needs IT. These two need
  IT: a VS Code that the company controls, and a proxy that blocks npm.
- Never guess a cause. Write the error text that you saw.

## After the report
Tell the user, in Norwegian, to copy the block and send it to the workshop
host. Say it once. Say it in one sentence.

Then say that `example.docx` and `node_modules` are safe to delete.
