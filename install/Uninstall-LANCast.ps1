[CmdletBinding()]
param(
    [string]$InstallPath = 'C:\LANCast',
    [switch]$KeepFiles,
    [switch]$Unattended
)

$ErrorActionPreference = 'Stop'
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath 'powershell.exe' -ArgumentList @('-ExecutionPolicy','Bypass','-NoProfile','-File',$PSCommandPath) + $MyInvocation.UnboundArguments -Verb RunAs
    exit 0
}

function Get-FakeGatewayFromCidr($Value) {
    $o = (($Value -split '/')[0]) -split '\.'
    return "$($o[0]).$($o[1]).$($o[2]).254"
}

$statePath = Join-Path $InstallPath 'install-state.json'
$state = $null
if (Test-Path $statePath) { $state = Get-Content $statePath -Raw | ConvertFrom-Json }

if (-not $Unattended) {
    $go = Read-Host 'Confirmer la desinstallation ? [O/n]'
    if ($go -match '^(n|N)') { exit 0 }
}

$taskName = 'LANCast SignalServer'
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

if (Get-NetFirewallRule -DisplayName 'WebRTC LAN-VIDEO' -ErrorAction SilentlyContinue) {
    Remove-NetFirewallRule -DisplayName 'WebRTC LAN-VIDEO'
}

if ($state -and $state.LocalIp) {
    $ip = Get-NetIPAddress -InterfaceAlias 'LAN-VIDEO' -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object IPAddress -eq $state.LocalIp
    if ($ip) { Remove-NetIPAddress -InterfaceAlias 'LAN-VIDEO' -IPAddress $state.LocalIp -Confirm:$false }
}

if ($state -and $state.FakeRoute -and $state.Cidr) {
    $fakeGw = Get-FakeGatewayFromCidr $state.Cidr
    $route = Get-NetRoute -InterfaceAlias 'LAN-VIDEO' -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Where-Object NextHop -eq $fakeGw
    if ($route) { Remove-NetRoute -InterfaceAlias 'LAN-VIDEO' -NextHop $fakeGw -Confirm:$false }
}

$edgePolicy = 'HKLM:\Software\Policies\Microsoft\Edge\WebRtcLocalIpsAllowedUrls'
if (Test-Path $edgePolicy) { Remove-Item $edgePolicy -Recurse -Force }

$startup = [Environment]::GetFolderPath('Startup')
foreach ($name in @('Lancer_Viewer.lnk','Lancer_Source.lnk')) {
    $p = Join-Path $startup $name
    if (Test-Path $p) { Remove-Item $p -Force }
}

if (-not $KeepFiles -and (Test-Path $InstallPath)) { Remove-Item $InstallPath -Recurse -Force }
Write-Host 'LANCast desinstalle. Note : la carte LAN-VIDEO conserve son nom.' -ForegroundColor Green
