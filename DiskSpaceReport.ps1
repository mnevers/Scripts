<#
DiskSpaceReport.ps1

Creates CSV with all Servers either that are offline or are below 10% free space
#>
$list = Import-Csv C:\scripts\AllServers.csv
$liveServers = @()
$offlineServers = @()
$result = @()
$currentServer = ""
$date = Get-date -Format "MM-dd-yyyy"

$list.Name | ForEach-Object {
    #test connection first if successful add it to array of livePcs
    if (Test-Connection -ComputerName $_ -Count 1 -Quiet){
        $liveServers += $_
        echo "$_ passed connection test... Checking Disk Space"
    }else{
        $offlineServers += $_
        echo "$_ failed connection test... Ignoring it"
    }
}

$liveServers | ForEach-Object {
    $currentServer = $_
    Get-WmiObject Win32_LogicalDisk -ComputerName $_ -Filter "DriveType = 3" |
    Select-Object DeviceID,Size,FreeSpace | ForEach-Object {
        #if ($_.FreeSpace / $_.Size -le .2){           
            
             
            $temp = [Math]::Round(($_.FreeSpace / $_.Size) * 100)
            $temp1 = [Math]::Round($_.Freespace / 1GB)
            $temp2 = [Math]::Round($_.Size / 1GB)
            $result += New-Object PSObject -Property @{
                Name = $currentServer        
                Drive = $_.DeviceID    
                PercentFree = "$temp %"
                FreeSpace = "$temp1 GB"
                DiskSize = "$temp2 GB"
            }
        #}
    }
}

$offlineServers | ForEach-Object {
    $result += New-Object PSObject -Property @{
        Name = $_        
        Drive = "Offline Server"  
        PercentFree = "Offline Server"
        FreeSpace = "Offline Server"  
        DiskSize = "Offline Server"    
    }
}

$result| Export-Csv -Path "C:\Reports\DiskSpace.csv"