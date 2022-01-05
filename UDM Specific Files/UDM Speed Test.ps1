$jsonresultat = Get-Content -Path C:\Users\user\Documents\api.json | ConvertFrom-Json

$jsonresultat.data | where-object type -like "udm" | ForEach-Object{
	$_.{speedtest-status} | ForEach-Object {
    $upt = $_.xput_upload 
    }
    $_.{speedtest-status} | ForEach-Object {
    $dwnt = $_.xput_download
    }
}

    $up = [int]$upt
    $down = [int]$dwnt


#Write Results

write-host "<prtg>"
Write-Host "<result>"
Write-Host "<channel>Download</channel>"
Write-Host "<value>$($down)</value>"
Write-Host "<CustomUnit>Mb/s</CustomUnit>"
Write-Host "</result>"
Write-Host "<result>"
Write-Host "<channel>Upload</channel>"
Write-Host "<value>$($up)</value>"
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
