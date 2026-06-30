param(
    [int]$Port = 8080,
    [string]$BindIp,
    [string]$InterfaceAlias = 'LAN-VIDEO'
)

$ErrorActionPreference = 'Stop'
$Rooms = [hashtable]::Synchronized(@{})

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $time = Get-Date -Format 'HH:mm:ss'
    Write-Host "[$time] [$Level] $Message"
}

function Test-IPv4 {
    param([string]$Ip)
    if ([string]::IsNullOrWhiteSpace($Ip)) { return $false }
    $addr = $null
    return [System.Net.IPAddress]::TryParse($Ip, [ref]$addr) -and `
           $addr.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork -and `
           $Ip -match '^\d{1,3}(\.\d{1,3}){3}$'
}

function Get-LocalIPv4 {
    if (Test-IPv4 $BindIp) {
        $exists = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.IPAddress -eq $BindIp } |
            Select-Object -First 1
        if (-not $exists) {
            throw "L'IP demandee '$BindIp' n'existe sur aucune interface locale."
        }
        return $BindIp
    }

    $fromInterface = Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object { $_.IPAddress -notlike '169.254*' -and $_.IPAddress -ne '127.0.0.1' } |
        Select-Object -First 1 -ExpandProperty IPAddress

    if ($fromInterface) { return $fromInterface }

    $fallback = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object { $_.IPAddress -notlike '169.254*' -and $_.IPAddress -ne '127.0.0.1' } |
        Select-Object -First 1 -ExpandProperty IPAddress

    if ($fallback) { return $fallback }
    throw "Aucune IPv4 locale utilisable trouvee."
}

function Send-Response {
    param($Context, [int]$StatusCode, [string]$Body, [string]$ContentType = 'application/json')
    try {
        $response = $Context.Response
        $response.StatusCode = $StatusCode
        $response.ContentType = $ContentType
        $response.Headers.Add('Access-Control-Allow-Origin', '*')
        $response.Headers.Add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        $response.Headers.Add('Access-Control-Allow-Headers', 'Content-Type')
        $response.Headers.Add('Cache-Control', 'no-store')
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.OutputStream.Close()
    } catch {
        Write-Log "Send response error: $($_.Exception.Message)" 'ERROR'
    }
}

function Get-Body {
    param($Request)
    try {
        $reader = New-Object System.IO.StreamReader($Request.InputStream, $Request.ContentEncoding)
        return $reader.ReadToEnd()
    } catch { return '' }
}

try {
    $ip = Get-LocalIPv4
    $listener = [System.Net.HttpListener]::new()
    $listener.Prefixes.Add("http://$($ip):$Port/")
    $listener.Start()
} catch {
    Write-Log $_.Exception.Message 'ERROR'
    exit 1
}

Write-Log "LANCast SignalServer started on http://$ip`:$Port" 'OK'
Write-Log "Health: http://$ip`:$Port/health" 'OK'

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $method = $request.HttpMethod
        $path = $request.Url.AbsolutePath

        if ($method -eq 'OPTIONS') {
            Send-Response $context 200 '{"ok":true}'
            continue
        }

        if ($path -eq '/health') {
            $body = @{ ok=$true; server='LANCast SignalServer'; bindIp=$ip; port=$Port; rooms=$Rooms.Count; time=(Get-Date).ToString('s') } | ConvertTo-Json -Compress
            Send-Response $context 200 $body
            continue
        }

        if ($path -eq '/rooms') {
            $list = foreach ($roomName in $Rooms.Keys) {
                $roomData = $Rooms[$roomName]
                [pscustomobject]@{
                    room = $roomName
                    hasOffer = $roomData.ContainsKey('offer')
                    hasAnswer = $roomData.ContainsKey('answer')
                }
            }
            Send-Response $context 200 ($list | ConvertTo-Json -Compress)
            continue
        }

        if ($path -eq '/clear') {
            $room = $request.QueryString['room']
            if ([string]::IsNullOrWhiteSpace($room)) {
                $Rooms.Clear()
                Send-Response $context 200 '{"ok":true,"cleared":"all"}'
            } else {
                if ($Rooms.ContainsKey($room)) { $Rooms.Remove($room) }
                Send-Response $context 200 "{`"ok`":true,`"cleared`":`"$room`"}"
            }
            continue
        }

        if ($path -ne '/signal') {
            Send-Response $context 404 '{"error":"not found"}'
            continue
        }

        $room = $request.QueryString['room']
        $type = $request.QueryString['type']
        if ([string]::IsNullOrWhiteSpace($room) -or $type -notin @('offer','answer')) {
            Send-Response $context 400 '{"error":"missing or bad room/type"}'
            continue
        }

        if (-not $Rooms.ContainsKey($room)) {
            $Rooms[$room] = [hashtable]::Synchronized(@{})
        }

        if ($method -eq 'POST') {
            $body = Get-Body $request
            if ([string]::IsNullOrWhiteSpace($body)) {
                Send-Response $context 400 '{"error":"empty body"}'
                continue
            }
            $Rooms[$room][$type] = $body
            if ($type -eq 'offer' -and $Rooms[$room].ContainsKey('answer')) { $Rooms[$room].Remove('answer') }
            Send-Response $context 200 '{"ok":true}'
            continue
        }

        if ($method -eq 'GET') {
            if ($Rooms[$room].ContainsKey($type)) {
                Send-Response $context 200 $Rooms[$room][$type]
            } else {
                Send-Response $context 404 '{"empty":true}'
            }
            continue
        }

        Send-Response $context 405 '{"error":"method not allowed"}'
    } catch {
        Write-Log $_.Exception.Message 'ERROR'
    }
}
