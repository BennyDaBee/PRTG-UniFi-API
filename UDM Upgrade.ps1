$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json

$apUpgradeable = 0
Foreach ($entry in ($jsonresultat.data | where-object { $_.state -eq "1" -and $_.type -like "udm" -and $_.upgradable -eq "true"})){
	$apUpgradeable ++
}

#Write Results

write-host "<prtg>"


Write-Host "<result>"
Write-Host "<channel>Access Points Upgradeable</channel>"
Write-Host "<value>$($apUpgradeable)</value>"
Write-Host "<CustomUnit>UDM</CustomUnit>"
Write-Host "</result>"


write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}