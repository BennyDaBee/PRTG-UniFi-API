$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json


$downd = 0
$upd = 0
$jsonresultat.data | Where-Object type -like "udm" | ForEach-Object {
$_.wan1 | ForEach-Object {
$downd = $_.rx_rate 
}
}
$downd = $downd / 1000000

$jsonresultat.data | Where-Object type -like "udm" | ForEach-Object {
$_.wan1 | ForEach-Object {
$upd = $_.tx_rate 
}
}
$upd = $upd / 1000000
#Write Results

write-host "<prtg>"

Write-Host "<result>"
Write-Host "<float>1</float>"
Write-Host "<DecimalMode>2</DecimalMode>"
Write-Host "<channel>Download</channel>"
Write-Host "<value>$($downd)</value>"
Write-Host "<CustomUnit>Mb/s</CustomUnit>"
Write-Host "</result>"
Write-Host "<result>"
Write-Host "<float>1</float>"
Write-Host "<DecimalMode>2</DecimalMode>"
Write-Host "<channel>Upload</channel>"
Write-Host "<value>$($upd)</value>"
Write-Host "<CustomUnit>Mb/s</CustomUnit>"
Write-Host "</result>"

write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
