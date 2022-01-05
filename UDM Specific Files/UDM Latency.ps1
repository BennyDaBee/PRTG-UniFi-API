$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json


$jsonresultat.data | where-object type -like "udm" | ForEach-Object{
	$ms =  $_.uplink | Select-Object -ExpandProperty latency
}


#Write Results

write-host "<prtg>"
Write-Host "<result>"
Write-Host "<channel>Latency</channel>"
Write-Host "<value>$($ms)</value>"
Write-Host "<CustomUnit>ms</CustomUnit>"
Write-Host "</result>"
write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
