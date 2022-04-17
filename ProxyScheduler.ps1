$ScriptPath = Read-Host -Prompt "Full PowerShell path"
 
$ActionParams = @{
    Execute = "powershell.exe"
    Argument = "-executionpolicy bypass -windowstyle hidden -noprofile -noninteractive -nologo -file $ScriptPath"
}
$TriggerParams = @{
    Once = $true
    At = Get-Date
    RepetitionInterval = New-TimeSpan -Minutes (Read-Host "Interval in minutes > 1 | Интервал в минутах > 1")
    RepetitionDuration = New-TimeSpan -Hours (Read-Host "Duration in hours | Продолжительность в часах")
}
 
$NewTaskParams = @{
    Action = New-ScheduledTaskAction @ActionParams
    Trigger = New-ScheduledTaskTrigger @TriggerParams
    Settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries
    Principal = New-ScheduledTaskPrincipal -GroupId S-1-5-32-545
    Description = "Temporary patch to fix proxy settings | Временный фикс прокси"
}
 
$RegisterTaskParams = @{
    InputObject = New-ScheduledTask @NewTaskParams
    TaskName = "FixProxy"
    Force = $true
    User = Read-Host "Enter login as rolfnet\Login"
    Password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((Read-Host -AsSecureString -Prompt "Enter password")))
}
 
Register-ScheduledTask @RegisterTaskParams | Start-ScheduledTask
