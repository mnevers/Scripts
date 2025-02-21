Import-Module ActiveDirectory

$csvPath = $PSScriptRoot + "\OnboardUser.csv" 
$notset = ""

Write-Host "############################################"
Write-Host "|          OnboardUser.ps1 Script          |"
Write-Host "|          Created by Matt Nevers          |"
Write-Host "############################################"`n

$csv = (Get-Content -Raw $csvPath) -replace  '[^,\r\n]+', '"$&"' | ConvertFrom-Csv
Write-Host "Make sure there are no blank cells"
Write-Host "Imported Variables from OnboardUser.csv: "
$csv | Out-Host

$bool = Read-Host -Prompt "Are these variables correct? (y/n)"

if($bool -ne "y"){
    Write-Host "Exiting Offboard Script..."
    Exit 1
}

$fname = @()
$lname = @()
$cuser = @()
$tnum = @()

$csv.firstname | ForEach-Object {
    $fname += $_.Trim()
}
$csv.lastname | ForEach-Object {
    $lname += $_.Trim()
}
$csv.copyuser | ForEach-Object {
    $cuser += $_.Trim()
}
$csv.telephone | ForEach-Object {
    $tnum += $_.Trim()
}

$loop = 0
$loopEnd = $fname.Length - 1

Write-Host $loopEnd

function CreateUser {   
    #----------------Setup vars--------------------#

    $user = $fname[$loop].Substring(0,1).ToLower() + $lname[$loop].ToLower() #added tolower without test should be fine
    $email = $user + "@company.com"
    $fname[$loop] = $fname[$loop].Substring(0,1).ToUpper() + $fname[$loop].Substring(1,$fname[$loop].Length-1)
    $lname[$loop] = $lname[$loop].Substring(0,1).ToUpper() + $lname[$loop].Substring(1,$lname[$loop].Length-1)
    $fullname = $fname[$loop] + " " + $lname[$loop]

    $oldUsers = Get-ADUser -Filter * -SearchBase "DC=COMPANY,DC=LOCAL" | Select sAMAccountName

    #-----------Check for Duplicate UPNs-----------#

    $match = 0
    $oldTemp = "OLD"+$user
    $oldUsers | ForEach-Object {
        if($_.sAMAccountName -eq $oldTemp){
            $match = 1
        }elseif($_.sAMAccountName -eq $user){
            Write-Host "User(s) exist with same UPN"
            Write-Host "Exiting Offboard Script..."
            Exit 1
        }
    }

    if($match -eq 1){
        $bool = Read-Host "Disabled User(s) exist which once used the same UPN do you wish to continue? (y/n)"

        if($bool -ne "y"){
            Write-Host "Exiting Offboard Script..."
            Exit 1
        }
    }

    #-----------Create User from Copy--------------#

    if($cuser[$loop] -ne ""){
        Write-Host "Creating new user from copy user..."    
        $copy = Get-ADUser $cuser[$loop] -Properties StreetAddress,Office,City,postalCode,st,c,title,department,company,manager,division,employeeType,msDS-cloudExtensionAttribute1
        $newCity = $copy.City
        $testOU = "OU=Users,OU=" + $newCity + ",OU=HQ,dc=COMPANY,dc=com"
        New-ADuser -Name $fullname -EmailAddress $email -SamAccountName $user -DisplayName $fullname -GivenName $fname[$loop] -Surname $lname[$loop] -UserPrincipalName $email -Instance $copy -Accountpassword (ConvertTo-SecureString -AsPlainText "t3mp Gene# unit" -Force) -Enabled $true -Path $testOU
    }else{
        Write-Host "No Copy user given. Code only functions with a copy user, Exiting Code..."
        Exit 1
    }

    if($tnum[$loop] -ne ""){
        Set-ADUser -Identity $user -OfficePhone $tnum[$loop] #verify this works
    }else{
        $notset = $notset + "Telephone"
    }

    Set-ADUser -Identity $user -Replace @{proxyAddresses="SMTP:"+$email,"smtp:"+$user+"@COMPANY.mail.onmicrosoft.com" -split "\s"}
    Set-ADUser -Identity $user -Replace @{targetAddress="SMTP:"+$user+"@COMPANY.mail.onmicrosoft.com"}
    Set-ADUser -Identity $user -Replace @{mailNickname=$user}
    Get-ADUser -Identity $cuser[$loop] -Properties memberof | Select-Object -ExpandProperty memberof |  Add-ADGroupMember -Members $user

    if($notset -ne ""){
        Write-Host "The following has not been set: " +$notset+ " - Please correct in AD." `n
    }

    Write-Host "User Created: " $user

    if ($loop -eq $loopEnd){        
        Write-Host "Syncing Azure AD..."
        Invoke-Command -ComputerName util01.company.com -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }

        Exit 0
    }

    if($loop -le $loopEnd){
        $loop = $loop + 1
        CreateUser
    }
}

CreateUser
