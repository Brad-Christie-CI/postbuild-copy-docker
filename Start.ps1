Copy-Item "C:\wwwroot\*" -Destination "C:\inetpub\wwwroot\" -Recurse -Container -Force

$scriptBlock = "Start-Process `"C:\ServiceMonitor.exe`" -ArgumentList `"w3svc`" -NoNewWindow -Wait"
Start-Job -Name "ServiceMonitor" -ScriptBlock ([scriptblock]::Create($scriptBlock))

$keepRunning = $true
while ($keepRunning) {
  $lastCheck = Get-Date
  If (Wait-Job -Name "ServiceMonitor" -Timeout 15) {
    $keepRunning = $false
  }
}