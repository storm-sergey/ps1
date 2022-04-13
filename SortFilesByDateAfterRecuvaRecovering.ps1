$Src = Read-Host -Prompt "Source"                                                                                                                                                                                                             
$Dest = Read-Host -Prompt "Destination"

$UniqueName = ""
Get-ChildItem $Src | Sort-Object -Unique | Foreach-Object -EV Err -EA SilentlyContinue {
    
    # Check item is a duplicate
    if (($UniqueName -eq "") -Or (-Not ($_.Name.StartsWith($UniqueName)))) {
    
        # Get date for sorting
        $LastWriteDate = (Get-Item $_.FullName).LastWriteTime
        $CreationDate = (Get-Item $_.FullName).CreationTime
        $Date = if ($LastWriteDate -lt $CreationDate) {$LastWriteDate} else {$CreationDate}

        # Make new path 
        $YearPath = $Dest + "\" + $Date.Year
        $YearMonthPath = if ($Date.Month -ge 1 -and $Date.Month -le 13) {
            $YearPath + "\" + (Get-Culture).DateTimeFormat.GetMonthName($Date.Month)
        } else {
            $YearPath + "Other"
        }
    
        # Check the path existence
        if (-Not (Test-Path $YearMonthPath)) {
            New-Item -Path $YearMonthPath -ItemType Directory
        }

        # Fix squere brackets in the path
        $path = $_.FullName.Replace('[', '``[').Replace(']', '``]')
        Copy-Item -Path $path -Destination $YearMonthPath -Force
    
        # Remember for duplicate checking
        $UniqueName = $_.Name.Substring(0, $_.Name.LastIndexOf(".")) 
    }   
}

Read-Host -Prompt "Done, press enter"
