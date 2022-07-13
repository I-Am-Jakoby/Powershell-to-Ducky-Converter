Clear-Host 

$Root = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.FullName

. $Root\Version\logs.ps1

# Replace spaces with a comma and convert to csv with custom headers.
$logs -replace '     *',',' | 
ConvertFrom-Csv -Header Version,Description,Date | 
Out-GridView -Title 'Powershell to DuckyScript Update Log' -PassThru






























<#
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

$logs = Get-Content -Path $Root\Version\log.txt -Raw

#-------------------------------------------------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

#-------------------------------------------------------------------------------------------------------

$logForm                                 = New-Object system.Windows.Forms.Form
$logForm.StartPosition                   = "CenterScreen"
$logForm.Size                            = New-Object System.Drawing.Point(800,600)
$logForm.text                            = "Powershell to Ducky Script Converter"
$logForm.TopMost                         = $false
$logForm.MaximumSize                     = $logForm.Size
$logForm.MinimumSize                     = $logForm.Size
#$logBGImage                             = [system.drawing.image]::FromFile("$Root\Assets\BgImages\main.png")
#$logForm.BackgroundImage                = $BGImage
#$logForm.BackgroundImageLayout          = "None"

$logBox                                  = textBox -ml $true  -sx 750 -sy 450 -lx 15 -ly 50
$logBox.Enabled                          = $false
$logBox.text                             = $logs

$logTitle                                = Label -sx 25 -sy 10 -lx 15  -ly 15  -fc $black -text "Logs:"

$logForm.controls.AddRange(@($logBox,$logTitle))

[void]$logForm.ShowDialog()
#>