[CmdletBinding()]
param(
    [ValidateSet('Viewer','Source')][string]$Role,
    [string]$LocalIp,
    [string]$ViewerIp,
    [int]$Port = 8080,
    [string]$Cidr = '10.10.10.0/24',
    [string]$SourceId = 'PC02',
    [string]$Interface,
    [switch]$NoFakeRoute,
    [string]$InstallPath = 'C:\LANCast',
    [switch]$Unattended
)

$ErrorActionPreference = 'Stop'

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath 'powershell.exe' -ArgumentList @('-ExecutionPolicy','Bypass','-NoProfile','-File',$PSCommandPath) + $MyInvocation.UnboundArguments -Verb RunAs
    exit 0
}

function Ask($Text,$Default) {
    if ($Unattended) { return $Default }
    $r = Read-Host "$Text [$Default]"
    if ([string]::IsNullOrWhiteSpace($r)) { return $Default }
    return $r
}

function Get-CidrPrefixLength($Value) {
    if ($Value -notmatch '^\d{1,3}(\.\d{1,3}){3}/([0-9]|[1-2][0-9]|3[0-2])$') { throw "CIDR invalide : $Value" }
    return [int]($Value -split '/')[1]
}

function Get-FakeGatewayFromCidr($Value) {
    $o = (($Value -split '/')[0]) -split '\.'
    return "$($o[0]).$($o[1]).$($o[2]).254"
}

if (-not $Role) { $Role = Ask 'Role Viewer ou Source' 'Viewer' }
if (-not $Interface) { $Interface = Ask 'Interface reseau a dedier' 'Ethernet' }
if (-not $LocalIp) { $LocalIp = Ask 'IP locale' $(if ($Role -eq 'Viewer') { '10.10.10.10' } else { '10.10.10.11' }) }
if ($Role -eq 'Viewer') { $ViewerIp = $LocalIp }
if ($Role -eq 'Source' -and -not $ViewerIp) { $ViewerIp = Ask 'IP du Viewer' '10.10.10.10' }
if ($Role -eq 'Source' -and -not $SourceId) { $SourceId = Ask 'SourceId' 'PC02' }
$PrefixLength = Get-CidrPrefixLength $Cidr

New-Item -Path $InstallPath -ItemType Directory -Force | Out-Null
$statePath = Join-Path $InstallPath 'install-state.json'
$state = [ordered]@{ Status='Installing'; Role=$Role; LocalIp=$LocalIp; ViewerIp=$ViewerIp; Port=$Port; Cidr=$Cidr; PrefixLength=$PrefixLength; SourceId=$SourceId; InterfaceWas=$Interface; InstallPath=$InstallPath; FakeRoute=(-not $NoFakeRoute) }
$state | ConvertTo-Json | Set-Content -Path $statePath -Encoding UTF8

$adapter = Get-NetAdapter -Name $Interface -ErrorAction Stop
if ($adapter.Name -ne 'LAN-VIDEO') { Rename-NetAdapter -Name $Interface -NewName 'LAN-VIDEO' }

if (-not (Get-NetIPAddress -InterfaceAlias 'LAN-VIDEO' -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object IPAddress -eq $LocalIp)) {
    New-NetIPAddress -InterfaceAlias 'LAN-VIDEO' -IPAddress $LocalIp -PrefixLength $PrefixLength | Out-Null
}

if (-not $NoFakeRoute) {
    $fakeGw = Get-FakeGatewayFromCidr $Cidr
    if (-not (Get-NetRoute -InterfaceAlias 'LAN-VIDEO' -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Where-Object NextHop -eq $fakeGw)) {
        New-NetRoute -InterfaceAlias 'LAN-VIDEO' -DestinationPrefix '0.0.0.0/0' -NextHop $fakeGw -RouteMetric 9999 | Out-Null
    }
}

if (-not (Get-NetFirewallRule -DisplayName 'WebRTC LAN-VIDEO' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName 'WebRTC LAN-VIDEO' -Direction Inbound -Action Allow -Protocol Any -RemoteAddress $Cidr -LocalAddress $Cidr -Profile Any | Out-Null
}

$edgePolicy = 'HKLM:\Software\Policies\Microsoft\Edge\WebRtcLocalIpsAllowedUrls'
New-Item -Path $edgePolicy -Force | Out-Null
Set-ItemProperty -Path $edgePolicy -Name '1' -Value '*' -Type String

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$filesDir = Resolve-Path (Join-Path $scriptDir '..\fichiers')
if ($Role -eq 'Viewer') {
    Copy-Item (Join-Path $filesDir 'SignalServer.ps1') $InstallPath -Force
    Copy-Item (Join-Path $filesDir 'LANCast_Viewer_PC01.html') $InstallPath -Force
    $taskName = 'LANCast SignalServer'
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) { Unregister-ScheduledTask -TaskName $taskName -Confirm:$false }
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$InstallPath\SignalServer.ps1`" -Port $Port -BindIp $LocalIp -InterfaceAlias LAN-VIDEO"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal | Out-Null
    Start-ScheduledTask -TaskName $taskName
} else {
    Copy-Item (Join-Path $filesDir 'LANCast_Source_MultiFlux.html') $InstallPath -Force
}

$state['Status']='Installed'
$state['CompletedAt']=(Get-Date).ToString('s')
$state | ConvertTo-Json | Set-Content -Path $statePath -Encoding UTF8
Write-Host "LANCast installe : $Role / $LocalIp / Viewer $ViewerIp / Port $Port" -ForegroundColor Green
