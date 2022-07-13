#-------------------------------------------------------------------------------------------------------

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

#-------------------------------------------------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

. $Root\Tools\mainForm.ps1

. $Root\Tools\stripMenu.ps1
#-------------------------------------------------------------------------------------------------------

# endregion

$Form.ShowDialog()

#Main

# Free ressources

$Form.Dispose()