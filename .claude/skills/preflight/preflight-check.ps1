<#
.SYNOPSIS
    Agentic Edge - diagnose of the machine. It runs when the Word test fails.
.DESCRIPTION
    The script reads the machine and reports why the Word test failed. It
    installs nothing. It changes nothing. It writes no file. It prints one
    block of text. The skill puts that block into the report.

    Test-Tls opens a TLS connection and reads the issuer of the server
    certificate. It accepts every certificate, because it must read the
    issuer of a certificate that a proxy made. It sends no data. This is
    the only way to see that a proxy inspects the traffic.
#>

$ErrorActionPreference = 'SilentlyContinue'
$lines = New-Object System.Collections.ArrayList
function Add-Line { param($Area, $Status, $Detail)
    $null = $lines.Add([pscustomobject]@{ Omrade = $Area; Status = $Status; Detalj = $Detail }) }

function Test-Tls {
    param($HostName)
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.ReceiveTimeout = 8000; $client.SendTimeout = 8000
        $client.Connect($HostName, 443)
        $cb = [System.Net.Security.RemoteCertificateValidationCallback]{ param($a,$b,$c,$d) return $true }
        $ssl = New-Object System.Net.Security.SslStream($client.GetStream(), $false, $cb)
        $ssl.AuthenticateAsClient($HostName)
        $issuer = $ssl.RemoteCertificate.Issuer
        $ssl.Dispose(); $client.Close()
        return @{ Ok = $true; Issuer = $issuer }
    } catch { return @{ Ok = $false; Issuer = $_.Exception.Message } }
}

# --- PowerShell can run the script at all ---
$lang = $ExecutionContext.SessionState.LanguageMode
if ($lang -eq 'FullLanguage') { Add-Line 'PowerShell' 'OK' "$lang" }
else { Add-Line 'PowerShell' 'MANGLER' "$lang. IT sperrer skript pa maskinen." }

# --- VS Code, and its version ---
# `code` is on PATH only if the installer added it. Look at the install
# folder when the command is absent.
$codeCmd = Get-Command code -ErrorAction SilentlyContinue
$codeExe = $null
if ($codeCmd) { $codeExe = 'code' }
else {
    foreach ($p in @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd",
        "$env:ProgramFiles\Microsoft VS Code\bin\code.cmd")) {
        if (Test-Path $p) { $codeExe = $p; break }
    }
}
if ($codeExe) {
    $ver = (& $codeExe --version 2>&1 | Select-Object -First 1)
    try {
        $v = [version]($ver -replace '[^0-9\.].*$','')
        if ($v -ge [version]'1.131') { Add-Line 'VS Code' 'OK' "$ver" }
        else { Add-Line 'VS Code' 'MANGLER' "$ver er for gammel. Krev 1.131 eller nyere. https://code.visualstudio.com/download" }
    } catch { Add-Line 'VS Code' 'MANGLER' "Fant versjon '$ver'. Kunne ikke lese den." }
} else {
    Add-Line 'VS Code' 'MANGLER' 'Ikke installert. https://code.visualstudio.com/download'
}

# --- The hybrid markdown editor ---
# The setting is true by default, but an experiment can turn it off for one
# user. The file .vscode/settings.json in the root sets it for everybody.
# So this is a note, never a blocker.
# The script lives in .claude/skills/preflight/. The root of the repo is
# three folders up. .vscode/settings.json sits in that root.
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$ws = Join-Path $root '.vscode\settings.json'
if (Test-Path $ws) {
    Add-Line 'Hybrid markdown' 'OK' 'Satt i .vscode/settings.json i repoet.'
} else {
    Add-Line 'Hybrid markdown' 'MERK' 'Fant ikke .vscode/settings.json. Klonet du hele repoet?'
}

# --- Node and npm. The Word test needs npm, not only node ---
foreach ($t in @(
    @{ Cmd='node'; Navn='Node.js'; Lenke='https://nodejs.org/en/download' },
    @{ Cmd='npm';  Navn='npm';     Lenke='Folger med Node.js.' })) {
    $f = Get-Command $t.Cmd -ErrorAction SilentlyContinue
    if ($f) { Add-Line $t.Navn 'OK' ((& $t.Cmd --version 2>&1 | Select-Object -First 1)) }
    else    { Add-Line $t.Navn 'MANGLER' "Ikke installert. $($t.Lenke)" }
}

# --- The npm registry. The Word test downloads a package from it ---
# A proxy that inspects the traffic breaks npm. This is the most common
# cause on a machine that a company controls.
# The list below holds the usual products. Both branches print the issuer,
# so a product that the list does not know is still visible in the report.
# Never add a customer name to this list. This repo is public.
$t = Test-Tls 'registry.npmjs.org'
if (-not $t.Ok) {
    Add-Line 'npm-registeret' 'MANGLER' "Ingen kontakt. $($t.Issuer)"
} elseif ($t.Issuer -match 'Zscaler|Netskope|Palo Alto|Forcepoint|Blue Coat|Fortinet|McAfee|Sophos') {
    Add-Line 'npm-registeret' 'MANGLER' "Trafikken inspiseres av en proxy. Utsteder: $($t.Issuer). npm vil feile med SELF_SIGNED_CERT_IN_CHAIN. IT ma legge inn sertifikatet."
} else {
    Add-Line 'npm-registeret' 'OK' "Kontakt OK. Utsteder: $($t.Issuer)"
}

# --- Print. The skill reads this block ---
foreach ($r in $lines) { Write-Host ("{0,-18} {1,-9} {2}" -f $r.Omrade, $r.Status, $r.Detalj) }
