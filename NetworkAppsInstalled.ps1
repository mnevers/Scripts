$list = Import-Csv "C:\Scripts\AllWorkstations.csv" 
$list += Import-Csv "C:\Scripts\AllServers.csv"
$livePCs = @()
$result = @()
$Vendor = @()
$Name = @()
$Version = @()
$InstallLocation = @()
$IdentifiyingNumber = @()
$HostCount = @()
$ComputerNames = @()

$HostCount
$count = 0
$run = 0

$list.Name | ForEach-Object {
    #test connection first if successful add it to array of livePcs
    if (Test-Connection -ComputerName $_ -Count 1 -Quiet){
        $livePCs += $_
        echo "$_ passed connection test..."
    }else{
        echo "$_ failed connection test... Ignoring it"
    }
}

$livePCs | ForEach-Object {
    $strComputer = $_
    Get-WmiObject -Class Win32_Product -ComputerName $strComputer | Select Vendor,Name,Version,InstallLocation,IdentifyingNumber | ForEach-Object {
        
        if($run -eq 0){
            $Vendor += $_.Vendor
            $Name += $_.Name
            $Version += $_.Version
            $InstallLocation += $_.InstallLocation
            $HostCount += 1
            $ComputerNames += $strComputer
            $run = 1
        }else {
            $temp = 0
            
            for($i=0; $i -le $Name.Count; $i++){               
                if($Name[$i] -eq $_.Name){
                    if($Version[$i] -eq $_.Version){
                        $temp = 1
                        $HostCount[$i]++
                        $ComputerNames[$i] += ", "+ $strComputer
                    }
                }                            

            }
            if ($temp -eq 0){
                    $Vendor += $_.Vendor
                    $Name += $_.Name
                    $Version += $_.Version
                    $InstallLocation += $_.InstallLocation
                    $HostCount += 1
                    $ComputerNames += $strComputer
            }
        }
    }
    $count++
    $count
}


for($i=0; $i -le $Name.Count; $i++){               
   $result += New-Object PSObject -Property @{
        Vendor = $Vendor[$i]
        ApplicationName = $Name[$i]
        Version = $Version[$i]
        InstallLocation = $InstallLocation[$i]
        HostCount = $HostCount[$i]
        ComputerNames = $ComputerNames[$i]
    }
}                            


$result | Export-Csv -Path "C:\Scripts\AllInstalledAppsNetwork.csv"
