$ErrorActionPreference = "Stop"

Write-Output "Installing IIS defaults plus a few extras"
Install-WindowsFeature Web-Server # (defaults)
Install-WindowsFeature Web-App-Dev
Install-WindowsFeature Web-Net-Ext45
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature Web-Http-Redirect
Install-WindowsFeature Web-Log-Libraries

Write-Output "Installing remote web management service"
Install-WindowsFeature Web-Mgmt-Service

Write-Output "Enabling and configuring remote web management service"
$enableRemoteCmd = @"
REGEDIT4
[HKEY_LOCAL_MACHINE\Software\Microsoft\WebManagement\Server]
"EnableRemoteManagement"=dword:00000001
"@
Set-Content -Path "enableRemoteWebAdmin.reg" -Value $enableRemoteCmd
reg import .\enableRemoteWebAdmin.reg

Set-Service -Name WMSVC -StartupType Auto
net start WMSVC

netsh advfirewall firewall add rule name=”IIS Remote Management” dir=in action=allow service=WMSVC

Write-Output "Installing Web Deploy"
choco install webdeploy -y

Write-Output "Installing URLRewrite"
choco install urlrewrite -y

Write-Output "Installing DAC Framework"
choco install sql2016-dacframework -y

Write-Output "Installing DAC SqlDom"
choco install sql2016-sqldom -y

Write-Output "Installing SQLCMD"
choco install sqlserver-cmdlineutils -y

Write-Output "Installing dotnetcore-windowshosting"
choco install dotnetcore-windowshosting --version=2.1.7 -y

Write-Output "Installing Dot Net Framework 4.7.1"
choco install dotnet4.7.1 -y

Write-Output "Installing Dot Net Framework 4.7.2"
choco install dotnet4.7.2 -y