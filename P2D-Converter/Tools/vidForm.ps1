$Root = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.FullName

$Base = ([IO.FileInfo] $MyInvocation.MyCommand.Path).Directory.Parent.Parent.FullName

$imgs = "$Root\Assets\vidLinks"

. $Root\Tools\functions.ps1

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                                 = New-Object system.Windows.Forms.Form
$Form.StartPosition                   = "CenterScreen"
$Form.Size                            = New-Object System.Drawing.Point(1600,800)
$Form.text                            = "Powershell for Hackers"
$Form.TopMost                         = $false
$Form.MaximumSize                     = $Form.Size
$Form.MinimumSize                     = $Form.Size
$Form.BackColor                       = $gray

function pictureBox {
    [CmdletBinding()]
    param (
        [Parameter (Mandatory = $True)]
        [string] $p,

        [Parameter (Mandatory = $True)]
        [int] $lx,

        [Parameter (Mandatory = $True)]
        [int] $ly,

        [Parameter (Mandatory = $False)]
        [string] $url
    )


    $img = [Drawing.Image]::Fromfile($PSCmdlet.GetUnresolvedProviderPathFromPSPath($p))
    $pbx = [Windows.Forms.PictureBox]@{
        Size      = [Drawing.Size]::new($img.Size.Width, $img.Size.Height)
        Location  = [Drawing.Point]::new($lx, $ly)
        Image     = $img

    }
    $pbx.Add_Click({ Start-Process $url }.GetNewClosure())
    $pbx
}

$Title                              = Label -fs 25 -lx 35 -ly 15 -bc $gray -fc $black -text "Collection of my YouTube videos to help you build your own payloads"

$v1  = pictureBox -p "$imgs\1.png"  -lx 20  -ly 65 -url "https://www.youtube.com/watch?v=VPU7dFzpQrM"
$v2  = pictureBox -p "$imgs\2.png"  -lx 270 -ly 65 -url "https://www.youtube.com/watch?v=467YXWBlL9E"
$v3  = pictureBox -p "$imgs\3.png"  -lx 520 -ly 65 -url "https://www.youtube.com/watch?v=RmhzrCXWVsY"

$v4  = pictureBox -p "$imgs\4.png"  -lx 20  -ly 215 -url "https://www.youtube.com/watch?v=x6H96fxyQ-Y"
$v5  = pictureBox -p "$imgs\5.png"  -lx 270 -ly 215 -url "https://www.youtube.com/watch?v=pBBYLgYokDs"
$v6  = pictureBox -p "$imgs\6.png"  -lx 520 -ly 215 -url "https://www.youtube.com/watch?v=sc7uBxuwwYg"

$v7  = pictureBox -p "$imgs\7.png"  -lx 20  -ly 365 -url "https://www.youtube.com/watch?v=bPkBzyEnr-w"
$v8  = pictureBox -p "$imgs\8.png"  -lx 270 -ly 365 -url "https://www.youtube.com/watch?v=6lScbYNLtJ4"
$v9  = pictureBox -p "$imgs\9.png"  -lx 520 -ly 365 -url "https://www.youtube.com/watch?v=N1Vdkd7P_cM"

$v10 = pictureBox -p "$imgs\10.png" -lx 20  -ly 515 -url "https://www.youtube.com/watch?v=-XhhUfmQdCA"
$v11 = pictureBox -p "$imgs\11.png" -lx 270 -ly 515 -url "https://www.youtube.com/watch?v=WHEFrRq82pA"
$v12 = pictureBox -p "$imgs\12.png" -lx 520 -ly 515 -url "https://www.youtube.com/watch?v=e2Msu2CnFkM"

$v13 = pictureBox -p "$imgs\13.png" -lx 770  -ly 65 -url "https://www.youtube.com/watch?v=pQiwKUMK2x4"
$v14 = pictureBox -p "$imgs\14.png" -lx 1030 -ly 65 -url "https://www.youtube.com/watch?v=Qm7KeuuNvMI"
$v15 = pictureBox -p "$imgs\15.png" -lx 1280 -ly 65 -url "https://www.youtube.com/watch?v=Y6ylC1-NAvo"

$v16 = pictureBox -p "$imgs\16.png" -lx 770  -ly 215 -url "https://www.youtube.com/watch?v=TrOIdJ2JFUU"
$v17 = pictureBox -p "$imgs\17.png" -lx 1030 -ly 215 -url "https://www.youtube.com/watch?v=FUZmMt1JVh0"
$v18 = pictureBox -p "$imgs\18.png" -lx 1280 -ly 215 -url "https://www.youtube.com/watch?v=at00Glzzh8g"

$v19 = pictureBox -p "$imgs\19.png" -lx 770  -ly 365 -url "https://www.youtube.com/watch?v=rbDC9C0Unpg"
$v20 = pictureBox -p "$imgs\20.png" -lx 1030 -ly 365 -url "https://www.youtube.com/watch?v=vK5fYx5vlss"
$v21 = pictureBox -p "$imgs\21.png" -lx 1280 -ly 365 -url "https://www.youtube.com/watch?v=nBNmupIBI54"

#$v22 = pictureBox -p "$imgs\1.png" -lx 770  -ly 515 -url ""
#$v23 = pictureBox -p "$imgs\1.png" -lx 1030 -ly 515 -url ""
#$v24 = pictureBox -p "$imgs\1.png" -lx 1280 -ly 515 -url ""

$Form.controls.AddRange(@($Title,$v1,$v2,$v3,$v4,$v5,$v6,$v7,$v8,$v9,$v10,$v11,$v12,$v13,$v14,$v15,$v16,$v17,$v18,$v19,$v20,$v21))
$Form.ShowDialog()
$Form.dispose
