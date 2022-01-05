param(
	[string]$server = '192.168.1.1',
	[string]$port = '443',
	[string]$site = 'default',
	[string]$username = 'BennyTheBee',
	[string]$password = 'Guiliani4',
	[switch]$debug = $false
)

#Ignore SSL Errors
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}  

#Define supported Protocols
[System.Net.ServicePointManager]::SecurityProtocol = @("Tls12","Tls11","Tls","Ssl3")


# Confirm Powershell Version.
if ($PSVersionTable.PSVersion.Major -lt 3) {
	Write-Output "<prtg>"
	Write-Output "<error>1</error>"
	Write-Output "<text>Powershell Version is $($PSVersionTable.PSVersion.Major) Requires at least 3. </text>"
	Write-Output "</prtg>"
	Exit
}

# Create $controller and $credential using multiple variables/parameters.
[string]$controller = "https://$($server):$($port)"
[string]$credential = "`{`"username`":`"$username`",`"password`":`"$password`"`}"

# Start debug timer
$queryMeasurement = [System.Diagnostics.Stopwatch]::StartNew()

# Perform the authentication and store the token to myWebSession
try {
$null = Invoke-Restmethod -Uri "$controller/api/auth/login" -method post -body $credential -ContentType "application/json; charset=utf-8"  -SessionVariable myWebSession
}catch{
	Write-Output "<prtg>"
	Write-Output "<error>1</error>"
	Write-Output "<text>Authentication Failed: $($_.Exception.Message)</text>"
	Write-Output "</prtg>"
	Exit
}

#Query API providing token from first query.
try {
$jsona = Invoke-WebRequest -UseBasicParsing -Uri "$controller/proxy/protect/api/bootstrap" -WebSession $myWebSession 
}catch{
	Write-Output "<prtg>"
	Write-Output "<error>1</error>"
	Write-Output "<text>API Query Failed: $($_.Exception.Message)</text>"
	Write-Output "</prtg>"
	Exit
}

# Load File from Debug Log
# $jsonresultatFile = Get-Content '.\unifi_sensor2017-15-02-05-42-24_log.json'
# $jsonresultat = $jsonresultatFile | ConvertFrom-Json

# Stop debug timer
$queryMeasurement.Stop()


$jsona.Content | Out-File -FilePath C:\Users\user\Documents\papi.json



#Write Results

write-host "<prtg>"

Write-Host "<result>"
Write-Host "<channel>Response Time</channel>"
Write-Host "<value>$($queryMeasurement.ElapsedMilliseconds)</value>"
Write-Host "<CustomUnit>msecs</CustomUnit>"
Write-Host "</result>"

write-host "</prtg>"

# Write JSON file to disk when -debug is set. For troubleshooting only.
if ($debug){
	[string]$logPath = ((Get-ItemProperty -Path "hklm:SOFTWARE\Wow6432Node\Paessler\PRTG Network Monitor\Server\Core" -Name "Datapath").DataPath) + "Logs (Sensors)\"
	$timeStamp = (Get-Date -format yyyy-dd-MM-hh-mm-ss)

	$json = $jsonresultat | ConvertTo-Json
	$json | Out-File $logPath"unifi_sensor$($timeStamp)_log.json"
}
