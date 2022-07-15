<# ---- Just here for trouble shooting 
Add-Type -AssemblyName System.Windows.Forms
$form=New-Object System.Windows.Forms.Form
$form.StartPosition='CenterScreen'
#>

#-------------------------------------------------------------------------------------------------------

$MenuBar                      = New-Object System.Windows.Forms.MenuStrip
$payloadToolStripMenuItem     = new-object System.Windows.Forms.ToolStripMenuItem
$logsToolStripMenuItem        = new-object System.Windows.Forms.ToolStripMenuItem
#$viewLogsToolStripMenuItem   = new-object System.Windows.Forms.ToolStripMenuItem
$socialToolStripMenuItem      = new-object System.Windows.Forms.ToolStripMenuItem
$YtToolStripMenuItem          = new-object System.Windows.Forms.ToolStripMenuItem
$TwToolStripMenuItem          = new-object System.Windows.Forms.ToolStripMenuItem
$DcToolStripMenuItem          = new-object System.Windows.Forms.ToolStripMenuItem
$InToolStripMenuItem          = new-object System.Windows.Forms.ToolStripMenuItem


$Form.Controls.Add($MenuBar)

$MenuBar.Items.AddRange(@($logsToolStripMenuItem,$socialToolStripMenuItem,$payloadToolStripMenuItem))

#-------------------------------------------------------------------------------------------------------

$payloadToolStripMenuItem.Name = "payloadToolStripMenuItem"
$payloadToolStripMenuItem.Size = new-object System.Drawing.Size(35, 20)
$payloadToolStripMenuItem.Text = "&Build Payload"
function OnClick_payloadToolStripMenuItem(){powershell -w h -NoP -NonI -Exec Bypass "$Root\Tools\vidForm.ps1"}
$payloadToolStripMenuItem.Add_Click( { OnClick_payloadToolStripMenuItem } )

#-------------------------------------------------------------------------------------------------------

#$logsToolStripMenuItem.DropDownItems.AddRange(@($viewLogsToolStripMenuItem))
$logsToolStripMenuItem.Name = "logsToolStripMenuItem"
$logsToolStripMenuItem.Size = new-object System.Drawing.Size(51, 20)
$logsToolStripMenuItem.Text = "&Logs"
function OnClick_logsToolStripMenuItem(){powershell -w h -NoP -NonI -Exec Bypass "$Root\Version\logForm.ps1"}  
$logsToolStripMenuItem.Add_Click( { OnClick_logsToolStripMenuItem } )

#-------------------------------------------------------------------------------------------------------

$socialToolStripMenuItem.DropDownItems.AddRange(@($YtToolStripMenuItem, $TwToolStripMenuItem, $DcToolStripMenuItem, $InToolStripMenuItem ))
$socialToolStripMenuItem.Name = "socialToolStripMenuItem"
$socialToolStripMenuItem.Size = new-object System.Drawing.Size(67, 20)
$socialToolStripMenuItem.Text = "&Socials"

#-------------------------------------------------------------------------------------------------------

$YtToolStripMenuItem.Name = "YtToolStripMenuItem"
$YtToolStripMenuItem.Size = new-object System.Drawing.Size(152, 22)
$YtToolStripMenuItem.Text = "&YouTube"
function OnClick_YtToolStripMenuItem(){Start-Process https://www.youtube.com/iamjakoby?sub_confirmation=1}
$YtToolStripMenuItem.Add_Click( { OnClick_YtToolStripMenuItem } )

#-------------------------------------------------------------------------------------------------------

$TwToolStripMenuItem.Name = "TwToolStripMenuItem"
$TwToolStripMenuItem.Size = new-object System.Drawing.Size(152, 22)
$TwToolStripMenuItem.Text = "&Twitter"
function OnClick_TwToolStripMenuItem(){Start-Process https://twitter.com/I_Am_Jakoby}
$TwToolStripMenuItem.Add_Click( { OnClick_TwToolStripMenuItem } )

#-------------------------------------------------------------------------------------------------------

$DcToolStripMenuItem.Name = "DCToolStripMenuItem"
$DcToolStripMenuItem.Size = new-object System.Drawing.Size(152, 22)
$DcToolStripMenuItem.Text = "&Discord"
function OnClick_DcToolStripMenuItem(){Start-Process https://discord.gg/MYYER2ZcJF}
$DcToolStripMenuItem.Add_Click( { OnClick_DcToolStripMenuItem } )

#-------------------------------------------------------------------------------------------------------

$InToolStripMenuItem.Name = "InToolStripMenuItem"
$InToolStripMenuItem.Size = new-object System.Drawing.Size(152, 22)
$InToolStripMenuItem.Text = "&Instagram"
function OnClick_InToolStripMenuItem(){Start-Process https://www.instagram.com/i_am_jakoby/}
$InToolStripMenuItem.Add_Click( { OnClick_InToolStripMenuItem } )





