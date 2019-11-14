$ProgressPreference="SilentlyContinue"
$ErrorActionPreference = "Stop"

#Replace to your present SQL iso path
$iso_path = "C:\Utilities\sql_developer.iso"


Write-Output "Mounting SQL Developer ISO"
$volumeInfo = Mount-DiskImage -ImagePath $iso_path -PassThru | Get-Volume
$driveInfo = Get-PSDrive -Name $volumeInfo.DriveLetter
Push-Location -Path $driveInfo.Root


#change the SQL password as per your need
Write-Output "Installing Sql Server"
Start-Process -FilePath ".\setup.exe" -ArgumentList "/ACTION=Install /Q /IACCEPTSQLSERVERLICENSETERMS /FEATURES=SQLEngine /INSTANCENAME=MSSQLSERVER /SECURITYMODE=SQL /SAPWD=Test1234! /SQLSVCACCOUNT=`"NT Service\MSSQLSERVER`" /AGTSVCACCOUNT=`"NT Service\SQLSERVERAGENT`" /SQLSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS=BUILTIN\Administrators /BROWSERSVCSTARTUPTYPE=Automatic /TCPENABLED=1" `
    -Wait

Write-Output "Un-mounting SQL Server ISO"
Pop-Location
Dismount-DiskImage -ImagePath $iso_path
Remove-Item -Recurse $iso_path


Write-Output "Opening firewall port for remote connections to SQL Server"
netsh advfirewall firewall add rule name = SQLPort dir = in protocol = tcp action = allow localport = 1433 remoteip = localsubnet

Write-Output "Installing PackageProvider for Powershell"
Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force

Write-Output "Installing Sql Server Provider for Powershell"
Install-Module -Name SqlServer -Force

if (-not (Get-Command Invoke-Sqlcmd -ErrorAction SilentlyContinue)) {
    Write-Error "Unabled to find Invoke-SqlCmd cmdlet"
}

if (-not (Get-Module -Name SqlServer | Where-Object {$_.ExportedCommands.Count -gt 0})) {
    Write-Error "The SqlServer module is not loaded"
}

if (-not (Get-Module -ListAvailable | Where-Object Name -eq SqlServer)) {
    Write-Error "Can't find the SqlServer module"
}

Update-module sqlserver -Force

Import-Module SqlServer -Force -ErrorAction Stop 