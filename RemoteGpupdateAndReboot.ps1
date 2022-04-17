$SourceOU = Read-Host -Prompt "Get OU like OU=OU-Name,...,OU=OU-Name,DC=corp,...,DC=com"
$Computers = (Get-ADComputer -SearchBase $SourceOU -Filter *).Name
$LogFile = ReadHost -Prompt "Get log file full path"
 
$UserName = Read-Host -Prompt "domain\login"
$SecurePassword = Read-Host "Enter Password" -AsSecureString
[SecureString]$SecureString = $SecurePassword | ConvertTo-SecureString
[PSCredential]$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecureString
 
[int]$Errors = 0
[int]$Success = 0
foreach ($Computer in $Computers) {  
    Try {
        Invoke-Gpupdate -Computer $Computer -Force
        Restart-Computer -ComputerName $Computer -Credential $Creds -Force -Verbose -ErrorAction SilentlyContinue
        $global:Success = $global:Success + 1
    } Catch {
        Write-host  -BackgroundColor red -ForegroundColor White
        $global:Errors = $global:Errors + 1
        "Error gpupdate & reboot for $Computer" | out-file $LogFile -append 
    }
}
 
"($(Get-Date)) OU-Computers: $($Computers.Count) | All: $([int]$Success + [int]$Errors) | Success: $Success | Errors: $Errors" | out-file $LogFile -append   
