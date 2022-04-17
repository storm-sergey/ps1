#region Settings
 
# Automatically detect settings
# Автоматическое определение параметров
$AutoDetect = $false
 
# Use automatic configuration script
# Использовать сценарий автоматической настройки
$AutoConfig = $true
$AutoConfigURL = "http://*.pac"
 
# Use a proxy server for your LAN
# Использовать прокси-сервер для локальных подключений
$ProxyEnable = $false
$ProxyServer = "proxy-address:port"
 
# Bypass proxy server for local addresses
# Не использовать прокси-сервер для локальных адресов
$ProxyOverride = $true
 
#endregion
 
 
Get-Command reg
$keyname = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
 
#region Automatic configuration
$AutoDetectVal = if($AutoDetect) {1} else {0}
reg add $keyname /v "AutoDetect" /t "REG_DWORD" /d $AutoDetectVal /f
 
if($AutoConfig) {
    reg add $keyname /v "AutoConfigURL" /t "REG_SZ" /d $AutoConfigURL /f
} else {
    reg delete $keyname /v "AutoConfigURL" /f
}
#endregion
 
#region Proxy server
$ProxyEnableVal = if($ProxyEnable) {1} else {0}
reg add $keyname /v "ProxyEnable" /t "REG_DWORD" /d $ProxyEnableVal /f
reg add $keyname /v "ProxyServer" /t "REG_SZ" /d $ProxyServer /f
 
if ($ProxyOverride) {
    reg add $keyname /v "ProxyOverride" /t "REG_SZ" /d "<local>" /f
} else {
    reg delete $keyname /v "ProxyOverride" /f
}
#endregion
