#Make sure you download the Sitecore_9_solrssl.ps1 and pssolrservice.ps1 to install on sitecore
#Update the path as per you location of downloaded solr ZIP

expand-archive -path 'C:\Utilities\solr-7.5.0.zip' -destinationpath 'C:\'

[Environment]::SetEnvironmentVariable("SOLR_HOME", $null, "Machine")

[Environment]::SetEnvironmentVariable("SOLR_HOME", "C:\solr-7.5.0\server\solr", "Machine")

#$service = Get-WmiObject -Class Win32_Service -Filter "Name='pssolrservice'"
#$service.delete()

Set-Location -Path C:\Utilities


Copy-Item "C:\Utilities\Sitecore_9_solrssl.ps1" -Destination "C:\solr-7.5.0\server\etc"

Write-Output "Making SOLR to run on SSL"
Set-Location -Path "C:\solr-7.5.0\server\etc"
Invoke-Expression -Command "C:\solr-7.5.0\server\etc\Sitecore_9_solrssl.ps1 -Clobber"
Write-Output "Making SOLR to run on SSL Completed"


Write-Output "Updating solr.in.cmd"
Write-Output "Adding - set SOLR_SSL_KEY_STORE=C:\solr-7.5.0\server\etc\solr-ssl.keystore.jks to solr.in.cmd"
Add-Content C:\solr-7.5.0\bin\solr.in.cmd "set SOLR_SSL_KEY_STORE=C:\solr-7.5.0\server\etc\solr-ssl.keystore.jks"
Write-Output "Adding - set SOLR_SSL_KEY_STORE_PASSWORD=secret to solr.in.cmd"
Add-Content C:\solr-7.5.0\bin\solr.in.cmd "set SOLR_SSL_KEY_STORE_PASSWORD=secret"
Write-Output "Adding - set SOLR_SSL_TRUST_STORE=C:\solr-7.5.0\server\etc\solr-ssl.keystore.jks to solr.in.cmd"
Add-Content C:\solr-7.5.0\bin\solr.in.cmd "set SOLR_SSL_TRUST_STORE=C:\solr-7.5.0\server\etc\solr-ssl.keystore.jks"
Write-Output "Adding - set SOLR_SSL_TRUST_STORE_PASSWORD=secret to solr.in.cmd"
Add-Content C:\solr-7.5.0\bin\solr.in.cmd "set SOLR_SSL_TRUST_STORE_PASSWORD=secret"
Add-Content C:\solr-7.5.0\bin\solr.in.cmd "set SOLR_HOST=localhost"
Write-Output "Updating solr.in.cmd Completed"

netsh.exe advfirewall firewall add rule name="SOLR Port" dir=in action=allow protocol=TCP localport=8983

Write-Output "Making SOLR windows service"
Set-Location -Path C:\Utilities
Invoke-Expression -Command "C:\Utilities\pssolrservice.ps1 -SetUp"
Write-Output "Making SOLR windows service Completed"

#.\pssolrservice.ps1 -SetUp

Write-Output "Starting pssolrservice"
Start-Service -Name "pssolrservice"
Write-Output "pssolrservice Started Successfully"