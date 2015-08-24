﻿<#
.SYNOPSIS
    Designed to automatically upload .tvs files in a folder structure automatically
    generated based on the case number supplied by the GFI Support CRM.
.DESCRIPTION
    
.NOTES
    File Name      : TVRecordingsAutoUpload.ps1
    Author         : Leonardo Faoro (leonardo.faoro@gfi.com)
    Prerequisite   : PowerShell V3 over Vista and upper.
    Copyright      : 2015 GFI Software Ltd. (www.gfi.com)
.LINK
    Script posted over:
    https://github.com/GFISoftware/PowerShell
#>

#TODO: monitor RS folder - work in progress

function Submit-Recordings {

[CmdletBinding()]
Param(
    #[Parameter(Mandatory=$True)]
    [string]$caseNumber
)

# Helper functions
function Get-Clipboard {
  if ($Host.Runspace.ApartmentState -eq 'STA') {
        Add-Type -Assembly PresentationCore
        [Windows.Clipboard]::GetText()
    } else {
    Write-Warning ('Run {0} with the -STA parameter to use this function' -f $Host.Name)
  }
}

Clear-Host

# Check compatibility
$psVersion = (get-host).Version.Major

if ($psVersion -lt 4) {
    write-host -ForegroundColor Yellow `
    "Your operating system is not updated, please install the latest version of Windows Management Framework: 
    KB2819745: http://www.microsoft.com/en-us/download/details.aspx?id=40855
     
    Press enter to open the Update page automatically
    "

    pause
    start http://www.microsoft.com/en-us/download/details.aspx?id=40855
    
}

$validCaseNumber = '^\w{3}\W\d{6}\W\d{6}$'
[String]$caseNumber
[String]$registryPath
$shareTVRecordings = "\\gfi.com\dfs\company data\support\support_ts\RS Recordings"

do {
    $caseNumber = Read-Host "Please enter your case number i.e. GFI-XXXX-XXXX"
    #$confirmed = read-host "Your case number is $caseNumber, correct? yes/no"

        if (Test-Path -Path HKLM:\SOFTWARE\Wow6432Node\TeamViewer) {
            $registryPath = "HKLM:\SOFTWARE\Wow6432Node\TeamViewer\DefaultSettings"
        } else {
            $registryPath = "HKLM:\SOFTWARE\TeamViewer\DefaultSettings"
        }

    if ($caseNumber -eq "Backup") {
        
        $RStmp = (Get-ItemProperty -Path $registryPath).SessionRecorderDirectory
        Write-Host ""
        Write-Host -ForegroundColor Green "Moving previous Remote Sessions to $RStmp\Sessions-Backup"
        Write-Host ""
        New-Item -Path "$RStmp\Sessions-Backup" -ItemType Directory >> $null
        Set-Location $RStmp
        Get-ChildItem -Filter *.tvs -Recurse | Move-Item -Destination "$RStmp\Sessions-Backup" -Force -Verbose
        pause
        exit
    }

    if ($caseNumber -eq "Change-Path") {

        $newPath = Read-Host "Enter the full path of your remote sessions recordings"
        $RStmp = (Get-ItemProperty -Path $registryPath).SessionRecorderDirectory
        Get-ItemProperty -Path $registryPath |`
        set-itemproperty -name SessionRecorderDirectory -value $newPath
        if (!(Test-Path -Path $newPath)) {
            New-Item -Path $newPath -ItemType Directory -Force
        }
        Write-Host ""
        Write-Host -ForegroundColor Green "Changed TeamViewer's setting: 'SessionRecorderDirectory' from '$RStmp' to '$newPath'"
        Write-Host ""
        pause
        exit
    }

    if (!($caseNumber -match $validCaseNumber)) {
        Write-Host ""
        Write-Host -ForegroundColor Red "Case Number doesn't validate, please try again."
        Write-Host ""
    }

} while (!($caseNumber -match $validCaseNumber))

#Recordings Local Path
$dirTVRecordings = (Get-ItemProperty -Path $registryPath).SessionRecorderDirectory
Write-Host -ForegroundColor Green "Your remote sessions path is: $dirTVRecordings"


$monthsList = @{
    01 = "January";
    02 = "February";
    03 = "March";
    04 = "April";
    05 = "May";
    06 = "June";
    07 = "July";
    08 = "August";
    09 = "September";
    10 = "October";
    11 = "November";
    12 = "December";
}


$increment = 0

$caseNumber -match '(\d{2})(\d{2})'
$caseYear = "20$($Matches[1])"
[int]$tmp = $Matches[2]
$caseMonth = "$($Matches[2])_" + $monthsList[$tmp]

$casePath = "$shareTVRecordings\$caseYear\$caseMonth\$caseNumber"

# Looping until the connection to $shareTVRecordings is restored
while (-Not (Test-Path -Path $shareTVRecordings)) {
    write-host -ForegroundColor Red "# Unable to connect to shared folder: $shareTVRecordings"
    Write-Host -ForegroundColor Yellow "# Make sure you have access priviledges and try again pressing (Enter)"
    pause
}

if (-not (Test-Path -Path $dirTVRecordings)) {
    Clear-Host
    write-host -ForegroundColor Red "# Unable to find path: $dirTVRecordings"
    Write-Host -ForegroundColor Yellow "# Press (Enter) to create the Folder or CTRL+C to Exit"
    pause
    New-Item -Path $dirTVRecordings -ItemType Directory >> $null
    Clear-Host
    write-host ""
    Write-Host -ForegroundColor Green "# Directory created: $dirTVRecordings"
    write-host ""
    Write-Host -ForegroundColor Yellow "# Inform IT to set your TeamViewer recordings path to: $dirTVRecordings"
    Write-Host -ForegroundColor Yellow "# then run this script again to upload your remote sessions"
    write-host ""
    pause
    exit
}

Set-Location $dirTVRecordings

Clear-Host

# Check if any *.tvs files are present in the directory

$files = Get-ChildItem -Filter *.tvs | Measure-Object
if ($files.Count -le 0) {
    Write-Host -ForegroundColor Yellow "# There are no .tvs files in $dirTVRecordings"
    
    pause
    exit
}

if (-not (Test-Path -Path $casePath)) { 
    New-Item -Path $casePath -ItemType directory >> $null
    Write-Host -ForegroundColor Green "# Folder '$caseNumber' created."
} else {
    Write-Host -ForegroundColor Yellow "# Folder '$caseNumber' already exists, incrementing"
}

# Get-ChildItem -Recurse | %{Rename-Item $_ -Force -NewName ("$caseNumber-{0}.tvs" -f $increment++)}
Get-ChildItem -Filter *.tvs <#-Recurse #> | Move-Item -Destination $casePath -Force -Verbose
write-host ""
Write-Host -ForegroundColor Green "# Remote session files moved to shared folder, YAY!"
write-host ""

Write-Host -ForegroundColor Green "# Sending confirmation email..."

$searcher = [adsisearcher]"(samaccountname=$env:USERNAME)"
$sender = $searcher.FindOne().Properties.mail
$senderName = $searcher.FindOne().Properties.name
$senderDepartment = $searcher.FindOne().Properties.department
$senderBranch = $searcher.FindOne().Properties.company

Send-MailMessage -SmtpServer CAS02GUKEQS.gfi.com `
-From $sender -To $sender,melvin.caruana@gfi.com,leonardo.faoro@gfi.com `
-Subject "RS recordings have been uploaded to case: $caseNumber" `
-Body "Hello $senderName from $senderDepartment at $senderBranch!

The Remote Session Recordings for case: '$caseNumber' have been uploaded successfully to:
$casePath
 
Thank you!"

#Please, make sure you've updated the case notes with the correct location of the Remote Session Recordings.

write-host ""
$casePath | clip.exe # thanks to Charlot for this idea
Write-Host -ForegroundColor Yellow "# Please, insert this path into your case notes: (already copied to clipboard)"
Write-Host -ForegroundColor Cyan $casePath
write-host ""

pause
exit
}

Submit-Recordings