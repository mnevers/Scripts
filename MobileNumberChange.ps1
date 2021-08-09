# MobileNumberChange.ps1
#
# This PowerShell script reads in the mobile number attribute from all AD users in a give OU
# Removes unncessary characters I.E " " "()" etc
# Adds a leading + and a 1 for USA country code if necessary
# Script will work on phone numbers that may have already been formatted properly as well
# Ignores blank mobile fields
#
# Author: Matthew Nevers

function SetPhone {
    Param(
        [Parameter(Position=0,Mandatory=$true)][String[]]$UserName,
        [Parameter(Position=1,Mandatory=$true)][String]$PhoneNum
    )
    echo $UserName
    echo $PhoneNum

    Get-ADUser -Filter "Name -eq '$UserName'" -Properties mobile | ForEach-Object { Set-ADUser $_ -mobile $PhoneNum }
}

$User = Get-ADUser -Filter * -SearchBase "OU=Employees,OU=Users,OU=Company,DC=Company,DC=lan" -Properties mobile
$count = 0    

$User | ForEach-Object  {
    $intphone = $_.mobile
    $intphone = $intphone -replace "[^0-9]"
    if($intphone.StartsWith(1)) {$intphone = "+" + $intphone} else {$intphone = "+1" + $intphone}
    
    if ($intphone -eq "+1") {echo "Ignore Empty Field"} else { SetPhone $_.Name $intphone }
    
}


