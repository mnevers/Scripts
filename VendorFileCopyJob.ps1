#add prefix and fileextension grab prefix info from child creationdate info
#run at 6am
#Be prefixed with ACH_yyyyMMdd_hhmmss_ 11 char

$date = "110321"#Get-date -Format "MMddyy"
$prefix = "ACH_"

#Write-Output $date

$files = Get-ChildItem -Path $path -File -Recurse | Sort-Object -Descending -Property LastWriteTime | Sort-Object -Descending -Property LastWriteTime | Select -First 4 | select Name,CreationTime
$delete = Get-ChildItem -Path C:\Temp\ -File -Recurse | select Name
$delete.Name | ForEach-Object { Remove-Item -Path "C:\Temp\$_"}

if (Test-Path -Path "C:\Temp\"){
    Write-Output "Path C:\Temp\ Exists"
}else{
    New-Item -Path "c:\Temp" -Name "fiserv" -ItemType "directory"
}

$files | ForEach-Object {    
    $tempName = $_.Name
    $tempDate = ($_.CreationTime.Year).ToString() + ($_.CreationTime.Month).ToString() + ($_.CreationTime.Day).ToString() + "_"
    $tempTime = ($_.CreationTime.Hour).ToString() + ($_.CreationTime.Minute).ToString() + ($_.CreationTime.Second).ToString()
    $tempTime
    $save = $prefix + $tempDate + $tempTime + '_' + $tempName + '.ach'
    Copy-Item -Path $path -Destination C:\Temp -Force 
    Rename-Item -Path "C:\Temp\$tempName" -NewName $save
    #Copy new items to verafin
}