$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json

$portCount = -1
$jsonresultat.data | Where-Object mac -like "00:00:00:00:00:00" | ForEach-Object{
$_.port_table | Where-Object up -eq "True" | ForEach-Object{
++$portCount
}
}



#Write Results

write-host "<prtg>"

Write-Host "<result>"
Write-Host "<channel>Ports (Total)</channel>"
Write-Host "<value>$($portCount)</value>"
Write-Host "<CustomUnit>Ports Active</CustomUnit>"
Write-Host "</result>"

write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
