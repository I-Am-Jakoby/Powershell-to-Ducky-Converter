$red   = '#ff0000'
$white = '#ffffff'
$blue  = '#1a80b6'
$black = '#000000'

# $connection = (test-connection 8.8.8.8 -Quiet)

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

function Label {
    [CmdletBinding()]
    param (

        [Parameter (Mandatory = $True)]
        [int] $sx,

        [Parameter (Mandatory = $False)]
        [int] $sy,

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
		Font      = [Drawing.Font]::new('Microsoft Sans Serif', 10)
		BackColor = $bc
		ForeColor = $fc
		Text      = $text
    }
}

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