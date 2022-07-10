Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------

$myVer = 1.1

$myFile = ($MyInvocation.MyCommand.Path)

$red   = '#ff0000'
$white = '#ffffff'
$blue  = '#1a80b6'
$black = '#000000'

#-------------------------------------------------------------------------------------------------------

function Root {
$parentPath = Split-Path -parent $myFile
$root = Split-Path -parent $parentPath
$base = Split-Path -parent $root
return $root, $base
}

$Root, $Base = Root

. $Root\Tools\functions.ps1


#-------------------------------------------------------------------------------------------------------



Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------

$Form                                 = New-Object system.Windows.Forms.Form
$Form.StartPosition                   = "CenterScreen"
$Form.Size                            = New-Object System.Drawing.Point(415,838)
$Form.text                            = "Powershell to Ducky Script Converter"
$Form.TopMost                         = $false
$Form.MaximumSize                     = $Form.Size
$Form.MinimumSize                     = $Form.Size
$BGImage                              = [system.drawing.image]::FromFile("$Root\Assets\BgImages\main.png")
$Form.BackgroundImage                 = $BGImage
$Form.BackgroundImageLayout           = "None"

#-------------------------------------------------------------------------------------------------------
. $Root\Tools\stripMenu.ps1
#-------------------------------------------------------------------------------------------------------

$SourceTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 240 
$OutputTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 335 -text "$Env:USERPROFILE\Desktop" 
$PayloadTextBox                       = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 430
$AuthorTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 495
$TargetTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 560
$DescriptionBox                       = textBox -ml $true  -sx 300 -sy 60 -lx 15 -ly 625

$Form.controls.AddRange(@($SourceTextBox, $OutputTextBox, $PayloadTextBox, $AuthorTextBox, $TargetTextBox, $DescriptionBox))

$btnFileBrowser                       = Button -sx 96 -sy 30 -lx 15  -ly 270 -bc $red -fc  $white -text Browse
$btnFolderBrowser                     = Button -sx 96 -sy 30 -lx 15  -ly 365 -bc $red -fc  $white -text Browse
$help                                 = Button -sx 96 -sy 30 -lx 100 -ly 750 -bc $blue -fc $white -text HELP
$button_ok                            = Button -sx 96 -sy 30 -lx 225 -ly 750 -bc $blue -fc $white -text Generate
#$form_main.Controls.Add($button_ok)
#$form_main.AcceptButton = $button_ok

$Form.controls.AddRange(@($btnFileBrowser, $btnFolderBrowser, $button_ok, $help))

$Version                              = Label -sx 25 -sy 10 -lx 15  -ly 775 -bc $black -fc $white -text "V. $myVer"

$Form.controls.AddRange(@($Version))

#region Logic 

#-------------------------------------------------------------------------------------------------------

#Source Browse button click event

$btnFileBrowser.Add_Click({
Add-Type -AssemblyName System.windows.forms | Out-Null
$OpenDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$OpenDialog.initialDirectory = $initialDirectory
$OpenDialog.ShowDialog() | Out-Null
$filePath = $OpenDialog.filename
$SourceTextBox.Text = $filePath 
})

#-------------------------------------------------------------------------------------------------------
#Output Browse button click event

$btnFolderBrowser.Add_Click({
$folder = Get-Folder
#Assigining the file choosen path to the text box
$OutputTextBox.Text = $folder 
})

#-------------------------------------------------------------------------------------------------------

#Help button click event

$help.Add_Click({
Start-Process "https://github.com/I-Am-Jakoby/Powershell-to-Ducky-Converter"
})
#-------------------------------------------------------------------------------------------------------

# The action on the button
$button_ok.Add_Click({

	$Source = $SourceTextBox.Text
	$Output = $OutputTextBox.Text
	$Payload = $PayloadTextBox.Text
	$Author = $AuthorTextBox.Text
	$TargetOS = $TargetTextBox.Text
	$Description = $DescriptionBox.Text
	
	if (!$Payload) { $Payload = "DuckyPayload" }

	if (!$Output) { $Output = [Environment]::GetFolderPath("Desktop") }

	$Delay = 250
	$FilePath = ($Output+"\"+$Payload+".txt")
	$converted = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes((Get-Content -Path $Source -Raw -Encoding UTF8)))

	$numChar = $converted.length
	$Time = $numChar/140 
	$estTime = [math]::Round($Time,2)

	function splitLines{
		While ($converted)
		{ 
		$x,$converted = ([char[]]$converted).where({$_},'Split',$incriment)
		$x -join ''
		}
	}

	echo "REM     This payload was generated using I am Jakoby's Powershell to DuckyScript Converter." >> $FilePath
	echo "REM     See how you can do the same here: https://github.com/I-Am-Jakoby/PowerShell-for-Hackers `n" >> $FilePath
	echo "REM --> $numChar Characters: Estimated $estTime seconds to execute `n" >> $FilePath

	if ($Payload)      { echo "REM		Title:       $Payload"        >> $FilePath}
	if ($Author)       { echo "REM		Author:      $Author"         >> $FilePath}
	if ($TargetOS)     { echo "REM		Target OS:   $TargetOS"       >> $FilePath}
	if ($Description)  { echo "REM		Description: $Description"    >> $FilePath}

	echo "" >> $FilePath

	if ($Keyboards.Checked){
	echo "DELAY 2000" >> $FilePath
	echo "ALT SHIFT" >> $FilePath
	}

	echo "DELAY 2000" >> $FilePath
	echo "GUI r" >> $FilePath
	echo "DELAY 2000" >> $FilePath
	echo "STRING powershell" >> $FilePath
	echo "DELAY $Delay" >> $FilePath
	echo "ENTER" >> $FilePath
	echo "DELAY $Delay" >> $FilePath
	echo "STRING powershell -enc " >> $FilePath
	echo "DELAY $Delay" >> $FilePath

	echo "STRING $converted" >> $FilePath
	echo "ENTER" >> $FilePath

	notepad $FilePath
	
	$form.Close()

})

#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------

#endregion

Main
#Free ressources
$Form.Dispose()