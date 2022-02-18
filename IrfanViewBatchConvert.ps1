$IMG_FORMAT = ".gif";
$IrfanView64Exe;
$Src;
$Dest;
 
#region Logic
function CheckIrfanView {
    $StandartPath = "C:\Program Files\IrfanView\i_view64.exe";
    if (Test-Path -Path $StandartPath -PathType Leaf) {
        $global:IrfanView64Exe = $StandartPath;
        return "Найден: " + $StandartPath;
    } else {
        Show("Для работы необходимо установить или указать путь IrfanView (i_view64.exe)");
        return "i_view64.exe не выбран";
    }
}
 
function ConvertImgToGif($Img) {
    $FullDestName = $Dest + "\" + [IO.Path]::GetFileNameWithoutExtension($Img.FullName) + $IMG_FORMAT;
    Start-Process -Wait -NoNewWindow -FilePath $IrfanView64Exe -ArgumentList $Img.FullName, /convert=$FullDestName;
}
 
function ConvertAllFiles {
    $SrcFiles = Get-ChildItem $Src;
    foreach ($Img in $SrcFiles) {
        # Проверяем, что файл не $IMG_FORMAT расширения
        if (-Not ([IO.Path]::GetExtension($Img.FullName) -eq $IMG_FORMAT)) {
            # Конвертим
            ConvertImgToGif($Img);
            # Удаляем сконверченный исходник, если результат кладём рядом с исходником
            if ($Src -eq $Dest) {
                Remove-Item $Img.FullName;
            }
        # Если папка назначения отличается от папки с исходниками,
        # то копируем файлы формата $IMG_FORMAT из папки источника
        } else {
            if (-Not ($Src -eq $Dest)) {
                Copy-Item $Img.FullName -Destination $Dest;
            }
        }
    }
    Show("Сконверчено!");
}
 
function Show($Message) {
    [System.Windows.Forms.Messagebox]::Show($Message);
}
 
function GetFile ($InitDir) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null;
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog;
    $OpenFileDialog.InitialDirectory = $InitDir;
    $OpenFileDialog.Filter = "Исполнительный файл (*.exe)|*.exe|Все файлы (*.*)|*.*";
    #$OpenFileDialog.ShowDialog();
    if ($OpenFileDialog.ShowDialog() -eq "OK")
    {
        $file += $OpenFileDialog.FileName;
    }
    return $file.ToString();
}
 
function GetDir ($InitDir) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null;
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog;
    $foldername.Description = "Выберите папку";
    $foldername.rootfolder = "MyComputer";
    $foldername.SelectedPath = $InitDir;
    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath;
    }
    return $folder.ToString();
}
#endregion
 
#region Gui
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
 
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);';
 
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0);
 
Add-Type -AssemblyName System.Windows.Forms;
[System.Windows.Forms.Application]::EnableVisualStyles();
 
$Form                        = New-Object system.Windows.Forms.Form;
$Form.ClientSize             = New-Object System.Drawing.Point(611,200);
$Form.text                   = "Конвертировать картинки в " + $IMG_FORMAT;
$Form.TopMost                = $false;
 
$Groupbox1                   = New-Object system.Windows.Forms.Groupbox;
$Groupbox1.height            = 130;
$Groupbox1.width             = 580;
$Groupbox1.text              = "Адреса:";
$Groupbox1.location          = New-Object System.Drawing.Point(13,15);
 
$GetIrfanView64Exe           = New-Object system.Windows.Forms.Button;
$GetIrfanView64Exe.text      = "IrfanView";
$GetIrfanView64Exe.width     = 82;
$GetIrfanView64Exe.height    = 30;
$GetIrfanView64Exe.location  = New-Object System.Drawing.Point(10,17);
$GetIrfanView64Exe.Font      = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
$GetIrfanView64Exe.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff");
 
$IrfanView64Dir              = New-Object system.Windows.Forms.Label;
$IrfanView64Dir.text         = CheckIrfanView;
$IrfanView64Dir.AutoSize     = $true;
$IrfanView64Dir.width        = 28;
$IrfanView64Dir.height       = 10;
$IrfanView64Dir.location     = New-Object System.Drawing.Point(97,27);
$IrfanView64Dir.Font         = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
 
$GetSrcDir                   = New-Object system.Windows.Forms.Button;
$GetSrcDir.text              = "Source";
$GetSrcDir.width             = 82;
$GetSrcDir.height            = 30;
$GetSrcDir.location          = New-Object System.Drawing.Point(10,53);
$GetSrcDir.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
$GetSrcDir.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff");
 
$SrcDir                      = New-Object system.Windows.Forms.Label;
$SrcDir.text                 = "Путь до папки с исходниками";
$SrcDir.AutoSize             = $true;
$SrcDir.width                = 28;
$SrcDir.height               = 10;
$SrcDir.location             = New-Object System.Drawing.Point(97,63);
$SrcDir.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
 
$GetDestDir                  = New-Object system.Windows.Forms.Button;
$GetDestDir.text             = "Destination";
$GetDestDir.width            = 82;
$GetDestDir.height           = 30;
$GetDestDir.location         = New-Object System.Drawing.Point(10,87);
$GetDestDir.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
$GetDestDir.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff");
 
$DestDir                     = New-Object system.Windows.Forms.Label;
$DestDir.text                = "Путь до папки с результатами";
$DestDir.AutoSize            = $true;
$DestDir.width               = 28;
$DestDir.height              = 10;
$DestDir.location            = New-Object System.Drawing.Point(97,99);
$DestDir.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10);
 
$Convert                     = New-Object system.Windows.Forms.Button;
$Convert.text                = "Сконвертировать";
$Convert.width               = 170;
$Convert.height              = 30;
$Convert.location            = New-Object System.Drawing.Point(13,155);
$Convert.Font                = New-Object System.Drawing.Font('Microsoft YaHei UI',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold));
$Convert.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff");
$Convert.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#4a90e2");
 
$Groupbox1.controls.AddRange(@($GetIrfanView64Exe,$IrfanView64Dir,$GetSrcDir,$SrcDir,$GetDestDir,$DestDir));
$Form.controls.AddRange(@($Convert,$Groupbox1));
 
$GetIrfanView64Exe.Add_Click({
    $global:IrfanView64Exe = GetFile("C:\Program Files");
    $IrfanView64Dir.text = "Найден: " + $global:IrfanView64Exe;
})
 
$GetSrcDir.Add_Click({
    $global:Src = GetDir("D:\");
    $global:Dest = $global:Src;
    $SrcDir.text = $global:Src;
    $DestDir.text = $global:Dest;
})
 
$GetDestDir.Add_Click({
    $global:Dest = GetDir($Src);
    $DestDir.text = $global:Dest;
})
 
$Convert.Add_Click({ ConvertAllFiles });
[void]$Form.ShowDialog();
#endregion
