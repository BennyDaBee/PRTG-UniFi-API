# PRTG-UniFi-API

These are examples files of how to create PRTG Sensors for a UniFi controller. There is some configuration needed and will be shown later down. 

The files should be put in the 
>C:\ProgramFiles(x86)\PRTG Network Monitor\Custom Sesnors\EXEML

folder. 

There is a 2 different API Pull files. There is one for UDMs and for all other controllers. 

>There is an issue with the scripts when passing to PRTG. PRTG will still output a bunch of decimal points, but you can change that. 

Right click that sensor that has a lot of decimals, click edit, settings, channel settings, and scroll down to Decimal. Click custom and assign your perfered decimal places

# API Pull File

The API pull file is just that. It querries the UniFi Controller and attempts to pull the API and put it in a JSON file that powershell will read and parse later on. 

```
param(
	[string]$server = '169.254.1.1',
	[string]$port = '8443',
	[string]$site = 'default',
	[string]$username = 'username',
	[string]$password = 'password',
	[switch]$debug = $false
)
```
The Server line is the IP address of your server.

The Port line is the port number of the web portion of the server.

The Site line is the site name in the controller. The first one in that was created on creation of the server will likely be default. 

The username is the username of an account that has admin on the server. 

### NOTE: IF YOU HAVE 2FA YOU MUST MAKE A LOCAL ACCOUNT

```
$jsona.Content | Out-File -FilePath C:\Users\user\Documents\api.json
```

I have it just outputting a file to my documents folder. Obviously you can change this.

# Individual Files

You will have to edit each file to match the path of the output above. I may test in a later version passing a variable between scripts to eliminate the need for files. 
