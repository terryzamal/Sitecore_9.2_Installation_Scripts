
$ErrorActionPreference = "Stop"

#Set-ExecutionPolicy Unrestricted -Force

Write-Output "Installing Sitecore Installation Framework"

Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force

Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2

Install-Module SitecoreInstallFramework -Repository SitecoreGallery -RequiredVersion 2.1.0 -AllowClobber -Force