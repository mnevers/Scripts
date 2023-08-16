$SourceDirectory = "D:\Storage\Btrfs\``[Unclassified``]\#2956\"
$DestinationDirectory = "\\nas\"
$ModBefore = "2023-8-09"
$ModAfter = "2023-4-27"
$pathRemove = "^D:\\Storage\\Btrfs\\\[Unclassified\]\\\#2956\\"

d:
cd $SourceDirectory
$results = @()
Write-Host "MAKE SURE TO CHANGE OUT FILE NAME - ABORT NOW!!!" -ForegroundColor Red
Write-Host "Getting All objects this may take a while..." -ForegroundColor Magenta
$sourceObjects = Get-ChildItem -Recurse | Where-Object {!$_.Attributes.HasFlag([System.IO.FileAttributes]::Directory) -and $_.Extension -ne ''} | Select-Object Name,LastWriteTime,FullName
$counter = 0
$sourceObjects | ForEach-Object{

    if ($_.LastWriteTime -ge $ModAfter-And $_.LastWriteTime -le $ModBefore) {
         $counter+=1
         Write-Host "Copying: "$_.FullName -ForegroundColor Green
         $s = $_.FullName
         #write-Host $s -ForegroundColor Yellow
         $s = $s -replace $pathRemove, ""
         $escapedFilename = [regex]::Escape($_.Name)
         $s = $s -replace $escapedFilename, ""
         Write-Host "Adding to FRSyn01 path:"$s -ForegroundColor Yellow
         $d = $DestinationDirectory+$s
         Write-Host "Destination: "$d -ForegroundColor Cyan         
         $remoteFile =  $d+$_.Name
         cd $SourceDirectory$s

         if (-not (Test-Path $remoteFile)){
            $t = "Copied "+$_.FullName
            $results += $t
            Write-Host "There is NO File in remote directory - Copying..." -ForegroundColor Magenta
            Write-Host $remoteFile -ForegroundColor DarkYellow
            #Copy-Item $_.Name -Destination $d
         }else{
            $t = "Did not Copy "+$_.FullName
            $results += $t
            Write-Host "There is File in remote directory - Not Copying!" -ForegroundColor Red
         }
         cd $SourceDirectory
        
    }else{
        Write-Host "Skipping: "$_.FullName
    }
}

$results | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
Write-Host "Objects: "$counter -ForegroundColor Green
$results | Out-File -FilePath C:\Scripts\Arthro\AprUsers.txt