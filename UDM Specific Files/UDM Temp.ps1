$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json

$jsonresultat.data | where-object type -like "udm" | ForEach-Object{
	$tempt = $_.temperatures | Where-Object type -EQ "cpu" | Select-Object -ExpandProperty value
}
 $temp = [int]$tempt
 
#Write Results

write-host "<prtg>"
Write-Host "<result>"
Write-Host "<channel>Tempratures</channel>"
Write-Host "<value>$($temp)</value>"
Write-Host "<CustomUnit>C</CustomUnit>"
Write-Host "</result>"
write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
