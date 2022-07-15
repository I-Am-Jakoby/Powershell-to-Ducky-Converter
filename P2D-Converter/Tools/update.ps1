Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

#-------------------------------------------------------------------------------------------------------

$Root = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.FullName

$Base = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.Parent.FullName

. $Root\Tools\functions.ps1

$theLogs = "$Root\Version\newLog.ps1"
iwr https://raw.githubusercontent.com/I-Am-Jakoby/Powershell-to-Ducky-Converter/main/P2D-Converter/Version/logs.ps1?dl=1 -O $theLogs
. $theLogs

#-------------------------------------------------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$UpdForm                              = New-Object system.Windows.Forms.Form
$UpdForm.StartPosition                = "CenterScreen"
$UpdForm.Size                         = New-Object System.Drawing.Point(415,838)
$UpdForm.text                         = $Root
$UpdForm.TopMost                      = $false
$UpdForm.MaximumSize                  = $UpdForm.Size
$UpdForm.MinimumSize                  = $UpdForm.Size
$BGImage                              = [system.drawing.image]::FromFile("$Root\Assets\BgImages\update.png")
$UpdForm.BackgroundImage              = $BGImage
$UpdForm.BackgroundImageLayout        = "None"
$UpdForm.add_FormClosing({$_.Cancel=$true})
$yes                                  = Button -sx 207 -sy 30 -lx 100 -ly 375 -bc $blue -fc  $white -text Yes
$no                                   = Button -sx 207 -sy 30 -lx 100 -ly 425 -bc $red  -fc  $white -text No

$logBox                               = textBox -ml $true  -sx 400 -sy 60 -lx 0 -ly 525 
$logBox.text                          = $logs[-1]

$myVer                                = [IO.File]::ReadAllText("$Root\Version\v.txt")

$Version                              = Label -sx 25 -sy 10 -lx 15  -ly 765 -bc $black -fc $white -text "Ver $myVer"

$UpdForm.controls.AddRange(@($yes, $no, $logBox, $Version))

#-------------------------------------------------------------------------------------------------------

# yes button click event

$yes.Add_Click({

    $ZipFile = "$Env:USERPROFILE\Desktop\Powershell-to-Ducky-Converter.zip"
    New-Item $ZipFile -ItemType File -Force
    $RepositoryZipUrl = "https://api.github.com/repos/I-Am-Jakoby/Powershell-to-Ducky-Converter/zipball/main" 
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile $ZipFile
    Expand-Archive -Path $ZipFile -DestinationPath $Env:USERPROFILE\Desktop\p2d-temp -Force
    $NF = Get-ChildItem -Path $Env:USERPROFILE\Desktop\p2d-temp -Name
    $FF = Get-ChildItem -Directory $Env:USERPROFILE\Desktop\p2d-temp\$NF -Name
    echo "Copy-Item $Env:USERPROFILE\Desktop\p2d-temp\$NF\$FF $Base -Force -Recurse; Rm -Path $Env:USERPROFILE\Desktop\p2d-temp, $ZipFile, $Env:USERPROFILE\Desktop\erase.ps1 -Recurse -Force" > $Env:USERPROFILE\Desktop\erase.ps1
    Remove-Item $theLogs	
    powershell -w h -NoP -NonI -Exec Bypass $Env:USERPROFILE\Desktop\erase.ps1
    $UpdForm.Visible = $false
    powershell -w h -NoP -NonI -Exec Bypass $Root\Tools\main.ps1

})

#-------------------------------------------------------------------------------------------------------
# no button click event

$no.Add_Click({
Remove-Item $theLogs
$UpdForm.Visible = $false; powershell -w h -NoP -NonI -Exec Bypass $Root\Tools\main.ps1
})
#-------------------------------------------------------------------------------------------------------


$UpdForm.ShowDialog()