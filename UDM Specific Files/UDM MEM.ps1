$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json


$jsonresultat.data | where-object type -like "udm" | ForEach-Object{
	$memt =  $_.'system-stats' | Select-Object -ExpandProperty mem
}
 $mem = [int]$memt

#Write Results

write-host "<prtg>"
Write-Host "<result>"
Write-Host "<channel>Usage</channel>"
Write-Host "<value>$($mem)</value>"
Write-Host "<CustomUnit>%</CustomUnit>"
Write-Host "</result>"
write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
