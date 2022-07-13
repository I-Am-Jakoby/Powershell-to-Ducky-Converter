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

#-------------------------------------------------------------------------------------------------------

$SourceTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 240 
$SourceTextBox.Enabled                = $false
$OutputTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 335 -text "$Env:USERPROFILE\Desktop" 
$OutputTextBox.Enabled                = $false
$PayloadTextBox                       = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 430 
$AuthorTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 495 
$TargetTextBox                        = textBox -ml $false -sx 300 -sy 20 -lx 15 -ly 560 
$DescriptionBox                       = textBox -ml $true  -sx 300 -sy 60 -lx 15 -ly 625 

$Form.controls.AddRange(@($SourceTextBox, $OutputTextBox, $PayloadTextBox, $AuthorTextBox, $TargetTextBox, $DescriptionBox))

#-------------------------------------------------------------------------------------------------------

$btnFileBrowser                       = Button -sx 96 -sy 30 -lx 15  -ly 270 -bc $red -fc  $white -text Browse
$btnFolderBrowser                     = Button -sx 96 -sy 30 -lx 15  -ly 365 -bc $red -fc  $white -text Browse
$help                                 = Button -sx 96 -sy 30 -lx 100 -ly 750 -bc $blue -fc $white -text HELP
$button_ok                            = Button -sx 96 -sy 30 -lx 225 -ly 750 -bc $blue -fc $white -text Generate
#$form_main.Controls.Add($button_ok)
#$form_main.AcceptButton = $button_ok

$Form.controls.AddRange(@($btnFileBrowser, $btnFolderBrowser, $button_ok, $help))

#-------------------------------------------------------------------------------------------------------

$myVer = [IO.File]::ReadAllText("$Root\Version\v.txt")

$Version                              = Label -sx 25 -sy 10 -lx 15  -ly 765 -bc $black -fc $white -text "Ver $myVer"

$Form.controls.AddRange(@($Version))

#-------------------------------------------------------------------------------------------------------

# Logic 

# Source Browse button click event

$btnFileBrowser.Add_Click({

getFile

})

#-------------------------------------------------------------------------------------------------------
# Output Browse button click event

$btnFolderBrowser.Add_Click({

$folder = Get-Folder

$OutputTextBox.Text = $folder 
})

#-------------------------------------------------------------------------------------------------------

# Help button click event

$help.Add_Click({
Start-Process "https://github.com/I-Am-Jakoby/Powershell-to-Ducky-Converter"
})
#-------------------------------------------------------------------------------------------------------

# The action on the button
$button_ok.Add_Click({

b64Payload	
	
$form.Close()

})

#-------------------------------------------------------------------------------------------------------