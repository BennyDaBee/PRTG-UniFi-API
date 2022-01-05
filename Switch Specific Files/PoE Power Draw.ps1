$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json

$jsonresultat.data | where-object mac -like "00:00:00:00:00:00" | ForEach-Object{
	$_.port_table | where-object poe_enable -eq "True" | ForEach-Object {
    $tpoeDraw = $_.poe_power 
    }
}

$poeDraw = [decimal]$tpoeDraw

#Write Results

write-host "<prtg>"

Write-Host "<result>"
Write-Host "<channel>Watts (Total)</channel>"
Write-Host "<float>1</float>"
Write-Host "<DecimalMode>2</DecimalMode>"
Write-Host "<value>$($poeDraw)</value>"
Write-Host "<CustomUnit>W</CustomUnit>"
Write-Host "</result>"

write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
