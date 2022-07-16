$red       = '#ff0000'
$white     = '#ffffff'
$blue      = '#1a80b6'
$black     = '#000000'
$lightGray = '#D3D3D3'
$gray   = '#808080'

#-----------------------------------------------------------------------------------------------------------

# $connection = (test-connection 8.8.8.8 -Quiet)

#-----------------------------------------------------------------------------------------------------------

Function Update {
$file1 = "$env:TMP\p2dVer.txt"
iwr https://raw.githubusercontent.com/I-Am-Jakoby/Powershell-to-Ducky-Converter/main/P2D-Converter/Version/v.txt -o $file1
$text = [IO.File]::ReadAllText($file1)
[IO.File]::WriteAllText($file1, $text.TrimEnd())
$gitVer = Get-Content -Path $file1 -TotalCount 1

if($myVer -lt $gitVer){powershell -w h -NoP -NonI -Exec Bypass "$Root\Tools\update.ps1" }

else{powershell -w h -NoP -NonI -Exec Bypass "$Root\Tools\main.ps1"}

Remove-Item $file1
}


function textBox {
    [CmdletBinding()]
    param (
        [Parameter (Mandatory = $True)]
        [bool] $ml,

        [Parameter (Mandatory = $True)]
        [int] $sx,

        [Parameter (Mandatory = $True)]
        [int] $sy,

        [Parameter (Mandatory = $True)]
        [int] $lx,

        [Parameter (Mandatory = $True)]
        [int] $ly,

        [Parameter (Mandatory = $False)]
        [string] $text

    )

    [Windows.Forms.TextBox]@{
        Multiline = $ml
        Size      = [Drawing.Size]::new($sx,$sy)
        Location  = [Drawing.Point]::new($lx, $ly)
        Font      = [Drawing.Font]::new('Microsoft Sans Serif', 10)
        Text      = $text
    }
}


#-----------------------------------------------------------------------------------------------------------

function Button {
    [CmdletBinding()]
    param (

        [Parameter (Mandatory = $True)]
        [int] $sx,

        [Parameter (Mandatory = $True)]
        [int] $sy,

        [Parameter (Mandatory = $True)]
        [int] $lx,

        [Parameter (Mandatory = $True)]
        [int] $ly,

        [Parameter (Mandatory = $False)]
        [string] $bc,

        [Parameter (Mandatory = $False)]
        [string] $fc,

        [Parameter (Mandatory = $False)]
        [string] $text
    )	

	[Windows.Forms.Button]@{
		Size      = [Drawing.Size]::new($sx,$sy)
		Location  = [Drawing.Point]::new($lx, $ly)
		Font      = [Drawing.Font]::new('Microsoft Sans Serif', 10)
		BackColor = $bc
		ForeColor = $fc
		Text      = $text
    }
}

#-----------------------------------------------------------------------------------------------------------

function Label {
    [CmdletBinding()]
    param (

        [Parameter (Mandatory = $False)]
        [int] $fs,

        [Parameter (Mandatory = $False)]
        [int] $lx,

        [Parameter (Mandatory = $True)]
        [int] $ly,

        [Parameter (Mandatory = $False)]
        [string] $bc,

        [Parameter (Mandatory = $False)]
        [string] $fc,

        [Parameter (Mandatory = $False)]
        [string] $text
    )	

	[Windows.Forms.Label]@{
            AutoSize  = $true
            width     = 25
            height    = 10
		Location  = [Drawing.Point]::new($lx, $ly)
		Font      = [Drawing.Font]::new('Microsoft Sans Serif', $fs)
		BackColor = $bc
		ForeColor = $fc
		Text      = $text
    }
}

#-----------------------------------------------------------------------------------------------------------

Function Get-Folder($initialDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

#-----------------------------------------------------------------------------------------------------------

function getFile {
	Add-Type -AssemblyName System.windows.forms | Out-Null
	$OpenDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
	$OpenDialog.initialDirectory = $initialDirectory
	$OpenDialog.filter = "PS1 (*.ps1)| *.ps1"
	$OpenDialog.ShowDialog() | Out-Null
	$filePath = $OpenDialog.filename
	$SourceTextBox.Text = $filePath 
}

#-----------------------------------------------------------------------------------------------------------

function MsgBox {

[CmdletBinding()]
param (	
[Parameter (Mandatory = $True)]
[Alias("m")]
[string]$message,

[Parameter (Mandatory = $False)]
[Alias("t")]
[string]$title,

[Parameter (Mandatory = $False)]
[Alias("b")]
[ValidateSet('OK','OKCancel','YesNoCancel','YesNo')]
[string]$button,

[Parameter (Mandatory = $False)]
[Alias("i")]
[ValidateSet('None','Hand','Question','Warning','Asterisk')]
[string]$image
)

Add-Type -AssemblyName PresentationCore,PresentationFramework

if (!$title) {$title = " "}
if (!$button) {$button = "OK"}
if (!$image) {$image = "None"}

[System.Windows.MessageBox]::Show($message,$title,$button,$image)
}

#-----------------------------------------------------------------------------------------------------------
function index {
$wshell = New-Object -ComObject wscript.shell
start notepad
Sleep 1
$message = "Hi Uber I am doing a keystroke injection attack with just software, I'm trying to incorporate an easter egg into here. What do you think?"
foreach ($char in [char[]]$message)
{
$delay = Get-Random -Minimum 40 -Maximum 200
$wshell.SendKeys($char);
Sleep -Milliseconds $delay
}
}
#-----------------------------------------------------------------------------------------------------------

function plainPayload {
	$Source = $SourceTextBox.Text
	$Output = $OutputTextBox.Text
	$Payload = $PayloadTextBox.Text
	$Author = $AuthorTextBox.Text
	$TargetOS = $TargetTextBox.Text
	$Description = $DescriptionBox.Text

	if (-not $SourceTextBox.Text.Trim()){
		[System.Windows.Forms.MessageBox]::Show("Please provide a Powershell File", "Oops!")
		return $false
	}

	if (!$Payload) { $Payload = "DuckyPayload" }

	$Delay = 250
	$FilePath = ($Output+"\"+$Payload+".txt")
	$file = Get-Content -Path $Source
	$file = $file.Trim()
	echo "REM     This payload was generated using I am Jakoby's Powershell to DuckyScript Converter." >> $FilePath
	echo "REM     See how you can do the same here: https://github.com/I-Am-Jakoby/PowerShell-for-Hackers `n" >> $FilePath

	if ($Payload)      { echo "REM		Title:       $Payload"        >> $FilePath}
	if ($Author)       { echo "REM		Author:      $Author"         >> $FilePath}
	if ($TargetOS)     { echo "REM		Target OS:   $TargetOS"       >> $FilePath}
	if ($Description)  { echo "REM		Description: $Description"    >> $FilePath}

	echo "" >> $FilePath
	echo "DELAY 2000" >> $FilePath
	echo "GUI r" >> $FilePath
	echo "DELAY 2000" >> $FilePath
	echo "STRING powershell" >> $FilePath
	echo "DELAY $Delay" >> $FilePath
	echo "ENTER" >> $FilePath
	echo "DELAY 2000" >> $FilePath

	foreach($line in $file) {$line.trim();echo "STRING $line" >> $FilePath}

	echo "ENTER" >> $FilePath
	notepad $FilePath
}
#-----------------------------------------------------------------------------------------------------------

function b64Payload {
	$Source = $SourceTextBox.Text
	$Output = $OutputTextBox.Text
	$Payload = $PayloadTextBox.Text
	$Author = $AuthorTextBox.Text
	$TargetOS = $TargetTextBox.Text
	$Description = $DescriptionBox.Text


	if (-not $SourceTextBox.Text.Trim()){
		[System.Windows.Forms.MessageBox]::Show("Please provide a Powershell File", "Oops!")
		return $false
	}

	if (!$Payload) { $Payload = "DuckyPayload" }

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

	echo "DELAY 2000" >> $FilePath
	echo "GUI r" >> $FilePath
	echo "DELAY 2000" >> $FilePath
	echo "STRING powershell" >> $FilePath
	echo "DELAY $Delay" >> $FilePath
	echo "ENTER" >> $FilePath
	echo "DELAY $Delay" >> $FilePath
	echo "STRING powershell -enc '" >> $FilePath
	echo "DELAY $Delay" >> $FilePath

	echo "STRING $converted'" >> $FilePath
	echo "ENTER" >> $FilePath
	notepad $FilePath

}