$SourceOU = Read-Host -Prompt "Get OU like OU=OU-Name,...,OU=OU-Name,DC=corp    ,...,DC=com"
$TargetOU = Read-Host -Prompt "Get OU like OU=OU-Name,...,OU=OU-Name,DC=corp    ,...,DC=com" 
$ErrorFlag = $false

Write-Host "Get user list .txt full address:"
$UserListTXT = Read-Host
Get-Content -Path $UserListTXT -Encoding UTF8 | ForEach-Object {
    $User = $_
    try {
        $ADUser = (Get-ADUser -SearchBase $SourceOU -Filter "Name -eq '$User'").distinguishedName
        Move-ADObject -Identity $ADUser -TargetPath $TargetOU
    } catch {
        if ($ErrorFlag -eq $false) {
	    Write-Host "------------------"
            Write-Host "Moving error with:"
	    Write-Host "------------------"
	    $global:ErrorFlag = $true
        }
        Write-Host $User
    }
}
