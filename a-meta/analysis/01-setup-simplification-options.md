# 01 — Options to simplify the workshop setup

Quick-mode research, 2026-08-28. Two gatherers, web sources. Every claim has a source.
Items marked **[unverified]** were not confirmed against an official document.

## Executive summary

1. **The local install is not the real problem. Corporate policy is.** VS Code, Git and
   Node.js each have a no-admin path on Windows. WSL2 and Docker Desktop do not. A single
   packaged image therefore makes the problem harder, not easier.
2. **Two paths remove the local install completely:** Claude Code on the web (Anthropic-hosted
   VM, browser only) and GitHub Codespaces with Anthropic's official dev container feature.
   Both need the customer's IT to allow one external service, not four installers.
3. **The hard blocker is not the tool list. It is the network and the endpoint agent.** Many
   enterprises proxy npm, and endpoint security (EDR) flags Claude Code's process tree.
   Neither problem disappears in a container.
4. **There is little published material on business staff running coding agents.** The
   governance writing that exists treats it as shadow IT and vibe coding, not as enablement.
   No training provider publishes an IT-requirements checklist for this case.
5. **Recommendation: keep the local path as the default, and add a browser fallback.** Ask
   each customer's IT four specific questions weeks in advance. Details in §5.

## 1. The delivery options

| Option | Participant installs | IT approval | Cost per person | Claude Code runs? |
|---|---|---|---|---|
| Claude Code on the web | Nothing (browser) | Network access, GitHub OAuth | Claude subscription | Yes |
| Codespaces + dev container | Nothing (browser) | Org owner must enable | Free tier, then hourly | Yes |
| Current manual install | VS Code, Git, Node.js, Claude | Per tool | Claude subscription | Yes |
| Docker Desktop | Docker Desktop | Admin rights, paid licence | Up to 24 USD/month | Yes |
| WSL2 | WSL2 and a distribution | Administrator | Free | Yes |
| IT push (Intune, winget) | Nothing | IT acts before the workshop | Free | Not directly |
| Cloud PC or VDI | Nothing (thin client) | Full provisioning project | Per-seat licence | **[unverified]** |
| StackBlitz, vscode.dev | Nothing | None | Free | **No** |

### Claude Code on the web

Anthropic hosts the VM. Each session is isolated, and GitHub credentials go through a proxy.
Source: `code.claude.com/docs/en/claude-code-on-the-web` and
`code.claude.com/docs/en/sandbox-environments`. The plan tier that gets this feature is
**[unverified]**. The participant needs a connected GitHub account to clone a repository.

### GitHub Codespaces with a dev container

Anthropic ships an official dev container feature,
`ghcr.io/anthropics/devcontainer-features/claude-code`. It installs Claude Code into any
Codespace. Login uses browser OAuth against an Anthropic account, or environment variables for
Bedrock, Vertex and Foundry. Source: `code.claude.com/docs/en/devcontainer`. Cost: a free tier
of 60 hours per month per person, then 0.18 USD per compute hour and 0.07 USD per GB of
storage. Source: `github.com/features/codespaces`. The customer's GitHub organisation owner
must enable Codespaces.

This is the option that matches the wish for one prepared image. The image is the dev
container. It holds Node.js, Git, the npm packages and Claude Code. The participant opens a
browser.

### Why WSL2 and Docker Desktop are the wrong direction

`wsl --install` and the Virtual Machine Platform feature need an elevated Administrator
session. Sources: `learn.microsoft.com/windows/wsl/install`, `github.com/microsoft/WSL`
issues 11109 and 3817. Group policy also blocks the Microsoft Store on many managed laptops.

Docker Desktop needs a paid per-seat licence for any company with 250 or more employees or
10M USD or more revenue. The price reaches 24 USD per user per month. Sources: gcn.com,
empiricapps.com. Every workshop customer of this size falls under that rule.

Both options need more IT approval than the four installers they replace.

### No-admin local installs

VS Code ships an official "User Installer" build. Node.js can go to `%APPDATA%\nodejs` from
the zip file with a manual PATH entry. `@jchip/nvm` is a no-admin Node manager for Windows.
Sources: `github.com/jchip/nvm`, a Medium post by yumingchang1991. `winget install
--scope user` exists for some packages. **[unverified]** for Git: a per-user path was not
confirmed.

### Browser-only editors do not work

StackBlitz WebContainers cannot operate a native binary. They operate JavaScript and WASM
only. Source: `developer.stackblitz.com/platform/webcontainers/browser-support`. vscode.dev
has no terminal that operates processes.

**Gap:** Gitpod, Coder, Google Cloud Shell, Firebase Studio, AWS Cloud9 and Replit were not
checked against official documents.

## 2. What corporate policy blocks, and why

AppLocker and WDAC work as allowlists by publisher signature, path or file hash. An unsigned
executable needs a hash rule, or AppLocker denies it. Sources: woshub.com, a7.de,
decryptiondigest.com.

| Tool | Friction level | Reason |
|---|---|---|
| VS Code, Git | Low | Signed installers, usually already on the allowlist |
| Node.js runtime | Low | Signed |
| npm packages | **High** | Native `.node` add-ons are often unsigned |
| Claude Code | **High** | IT must allowlist `claude.exe` and its child processes |
| WSL2, Docker Desktop | **Highest** | Admin rights and virtualization features |

Many enterprises do not allow direct access to `registry.npmjs.org`. They front it with Azure
Artifacts or JFrog Artifactory. Sources: oneuptime.com, docs.veracode.com. A laptop that
points at the public registry then fails. The current check does exactly this when it installs
the packages for the Word and PowerPoint test.

## 3. Endpoint security is the reported blocker

These reports are **anecdotal**. They are real reports from real users, not vendor statements.

- Claude Code shows false "Blocked by endpoint security" messages, also on machines with no
  EDR. Sources: `github.com/anthropics/claude-code` issues 58626 and 59292. The same issues
  confirm that IT must allowlist `claude.exe` plus `cmd.exe` and `bash.exe` as child processes.
- One EDR flagged Claude Code's access to the Windows credential store (DPAPI) as credential
  theft. Source: a Medium post by sebuzdugan, July 2026. Single author, one sample.
- Claude Code's PowerShell tool passes `-ExecutionPolicy Bypass` by default from version
  2.1.143. The environment variable
  `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1` turns this off. Sources:
  `github.com/anthropics/claude-code` issue 59581, blog.netnerds.net.

## 4. Anthropic's enterprise documentation

Anthropic publishes "Set up Claude Code for your organization" at
`code.claude.com/docs/en/admin-setup`. It covers a managed settings file with permissions, MCP
allowlists, model allowlists, hooks, sandbox and login method. Two delivery paths exist:

1. Server-managed settings pushed from the Claude.ai admin console at login. No MDM needed.
   Teams from version 2.1.38, Enterprise from version 2.1.30.
2. MDM or OS policy through Jamf, Kandji, Intune or Group Policy.

Install and login problems are covered at `code.claude.com/docs/en/troubleshoot-install`.

**Gap:** no Anthropic document that names the network domains to allowlist was found in this
pass.

## 5. What to ask the customer's IT department

No training provider publishes an IT-requirements checklist for this case. The searches found
only generic onboarding checklists. This list is therefore **our own inference** from the
policy material above.

Ask weeks in advance, not days. An AppLocker or WDAC change goes through change control.

1. Can the participants reach the public npm registry? If not, give the URL of the internal
   proxy and the permission to use it.
2. Add `claude.exe` and its child processes `cmd.exe` and `bash.exe` to the endpoint security
   allowlist.
3. Add VS Code, Git and Node.js to the AppLocker or WDAC allowlist by publisher rule.
4. Can the participants reach `claude.ai` and `code.claude.com`, and can they complete a
   browser OAuth login?

Question 4 alone decides whether the browser path works. Ask it first.

## 6. The AI-shift material that exists

No article was found that treats business staff running coding agents as a thing to enable.
The published material treats it as a risk to govern.

| Source | Title and date | What it says |
|---|---|---|
| Gartner | Enterprise AI Coding Agent Market, 2026 | Coding agents now act, not assist. New control needs. |
| Gartner | Press release, 2026-05-26 | 40% of enterprises will demote autonomous agents by 2027. |
| Forrester | The State Of Agentic AI In 2026 | Most companies chase, few catch. |
| Cloud Security Alliance | The Vibe Coding Governance Gap, 2026-06-02 | Research note on vibe-coding risk. |
| TechFinitive | Vibe coding is the new shadow IT | Practitioner framing of this exact case. |
| Wiz | What Is Shadow AI? | Vendor explainer on the governance response. |

Two numbers give the size of the pressure. A Microsoft UK survey from October 2025 reports
that 71% of employees used unapproved AI tools, and 51% weekly. IBM's Cost of a Data Breach
2025 reports that shadow-AI breaches cost 670,000 USD more on average. Both numbers reached
this report through secondary sources, not the originals.

The practical result for a workshop: the customer's security team reads this material. They
see the workshop as the risk it describes. A prepared answer to §5 changes that reading.

## 7. Recommendation

Do not build one image. Build two paths, and let each customer's IT pick.

**Path A, browser.** Claude Code on the web, or a Codespace with the Anthropic dev container
feature. The participant installs nothing. Confirm the plan tier and the GitHub organisation
setting first.

**Path B, local, simplified.** Keep the current four tools, but give a no-admin install route
for each one, and ask IT to push them through Intune or winget where possible.

The next work is not more research. It is one test: run the whole pre-workshop check inside a
Codespace with the Anthropic dev container feature, and measure what breaks.
