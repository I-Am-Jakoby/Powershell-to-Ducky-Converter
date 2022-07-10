Class Coordinate
{
    [int]$X
    [int]$Y
    Coordinate([int]$x,[int]$y)
    {
        $this.X = $x
        $this.Y = $y
    }
}
 
Class ScreenObject
{
    [Coordinate] hidden $OldPos
    [Coordinate]$CurPos
    [char] hidden $Symbol
 
    [void]Update()
    {}
 
    [void]Draw()
    {
        if ($this.CurPos.X -gt 0 -and $this.CurPos.X -lt [System.Console]::WindowWidth -and $this.CurPos.Y -gt 0 -and $this.CurPos.Y -lt [System.Console]::WindowHeight)
        {
            [Screen]::Instance().lines[$this.CurPos.Y][$this.CurPos.X]=$this.Symbol
        }       
    }
}
 
Class Player:ScreenObject
{
    [char]$Symbol = "A"
    [Coordinate]$CurPos
    [int]$Bombs = 2
    [int] $UsedBombs = 0
    [bool] hidden $JustLaunched = $false
    static [Player] hidden $thePlayer = [Player]::Instance()
 
    static [Player]Instance()
    {
        if ($null -eq [Player]::thePlayer)
        {
            [Player]::thePlayer = [Player]::new()
        }
        return [Player]::thePlayer
    }
    Player()
    {
        $this.Reset()
    }
    
    Reset()
    {
        $this.CurPos = [Coordinate]::new([console]::WindowWidth/2,[console]::WindowHeight-1)
        $this.OldPos = [Coordinate]::new([console]::WindowWidth/2,[console]::WindowHeight-1)
        $this.Bombs = 2
        $this.UsedBombs = 0
        $this.JustLaunched = $false
    }
 
    [void]Update([int[]]$keys)
    {
        $this.OldPos.X = $this.CurPos.X
        $this.OldPos.Y = $this.CurPos.Y
        if ([int][System.ConsoleKey]::LeftArrow -in $keys)
        {
            $this.CurPos.X -=1
            if ($this.CurPos.X -le 0)
            {
                $this.CurPos.X = [Console]::WindowWidth - 1
            }
        }        
        if ([int][System.ConsoleKey]::RightArrow -in $keys)
        {
            $this.CurPos.X +=1
            if ($this.CurPos.X -ge [Console]::WindowWidth)
            {
                $this.CurPos.X = 1
            }
        }
        
 
        if (([int][System.ConsoleKey]::Spacebar -in $keys) -and $this.Bombs -gt 0)
        {
            if ($this.JustLaunched -eq $false)
            {
                $this.JustLaunched = $true
                $this.Bombs -=1
                $this.UsedBombs +=1
                $scoreToAdd = [Game]::Instance().screenObjects.Count
                $enemiesToAdd = [int]([Math]::Floor($scoreToAdd/10))
                [Game]::Instance().Score+=$scoreToAdd
                [Game]::Instance().EnemiesAttacking+=$enemiesToAdd
                for ($i = 0;$i -lt [Game]::Instance().screenObjects.Count;$i++)
                {
                    if ([Game]::Instance().screenObjects[$i].CurPos.Y -gt 0)
                    {
                        [Game]::Instance().screenObjects[$i].Reset()
                    }
                }
            
                [Game]::Instance().AddEnemies($enemiesToAdd)
            }
        }
        elseif ([int][System.ConsoleKey]::Spacebar -notin $keys -and $this.JustLaunched -eq $true)
        {
            $this.JustLaunched = $false
        }
    }
    
}
 
Class Enemy:ScreenObject
{

    Enemy()
    {
        $this.Reset()
    }

    [void]Reset()
    {
        if ($null -ne $this.CurPos)
        {
            #if it's visible on screen move it
            if ($this.CurPos.Y -gt 0)
            {
                $this.CurPos.Y *=-1
                $this.CurPos.X =($Global:Random).Next([System.Console]::WindowWidth)
            }
            
        }

        else
        {
            $this.CurPos = [Coordinate]::new(($Global:Random).Next([System.Console]::WindowWidth),-1*($Global:Random).Next([System.Console]::WindowHeight))
        }
        if ($null -eq $this.OldPos){$this.OldPos = [Coordinate]::new($this.CurPos.X,$this.CurPos.Y)}
        $this.Symbol = [char]"v"#[char]($Global:Random).Next(65,91) if you want a random letter
    }
 
    [void]Update()
    {
        $this.OldPos.X = $this.CurPos.X
        $this.OldPos.Y = $this.CurPos.Y
 
        $this.CurPos.Y += ($Global:Random).Next(2)
 
        if (($Global:Random).Next(2) -eq 0)
        {
            if ([Player]::Instance().CurPos.X -gt $this.CurPos.X)
            {
                $this.CurPos.X+=1
            }
            elseif ([Player]::Instance().CurPos.X -lt $this.CurPos.X)
            {
                $this.CurPos.X-=1
            }
        }
 
        if ($this.CurPos.X -eq [Player]::Instance().CurPos.X -and $this.CurPos.Y -eq [Player]::Instance().CurPos.Y)
        {
            [Game]::Instance().GameOver = $true
        }
        
        elseif ($this.CurPos.Y -ge [Console]::WindowHeight)
        {
            [Game]::Instance().Score+=1
            $this.Reset()
 
            if (([Game]::Instance().Score % 10) -eq 0)
            {
                [Game]::Instance().screenObjects.Add([Enemy]::new())
                [Game]::Instance().EnemiesAttacking+=1
            }

            if (([Game]::Instance().Score % 50) -eq 0 -and [Player]::Instance().UsedBombs -lt 3 -and [Player]::Instance().Bombs -lt 10)
            {
                [Player]::Instance().Bombs+=1
            }
            return
        }
 
    }
 
}
 
class Display:ScreenObject
{
    static [Display] hidden$theDisplay = [Display]::Instance()
 
    static [Display]Instance()
    {
        if ($null -eq [Display]::theDisplay)
        {
            [Display]::theDisplay = [Display]::new()
        }
        return [Display]::theDisplay
    }
 
    [void]Draw()
    {
        
        $sb = [System.Text.StringBuilder]::new()
        $sb.AppendFormat("SCORE: {0:d3}  --  ENEMIES ATTACKING: {1:d3}  --  BOMBS: {2:d2}  --  TIME ALIVE: {3:mm\:ss\.fff}",@([Game]::Instance().Score,(([Game]::Instance().screenObjects.Count)),[Player]::Instance().Bombs,[Game]::Instance().timer.Elapsed));
        [Console]::SetCursorPosition(([Console]::WindowWidth-$sb.Length)/2,0)
        [Console]::Write($sb.ToString())
    }
 
}
 
 
class Screen
{
    static [Screen] hidden $theScreen = [Screen]::Instance()
    [char[][]]$lines = [char[][]]::new([System.Console]::WindowHeight,[Console]::WindowWidth)
    [char[]] hidden $empty = [char[]]::new([Console]::WindowWidth)
    static [Screen]Instance()
    {
        if ($null -eq [Screen]::theScreen)
        {
            [Screen]::theScreen = [Screen]::new()
            
            if ($Global:PSVersionTable.PSVersion.Major -gt 5)
            {
                [array]::Fill([char[]]([Screen]::theScreen.empty),[char]' ')
            }
            else
            {
                for($i=0;$i -lt [Screen]::theScreen.empty.Length;$i++){[Screen]::theScreen.empty[$i]=[char]' '}
            }
        }
        return [Screen]::theScreen
    }
 
 
    [void]Reset()
    {
 
        for ($l = 0; $l -lt $this.lines.Count; $l++)
        {
            if ($Global:PSVersionTable.PSVersion.Major -gt 5)
            {
                [array]::Fill([char[]]$this.lines[$l],[char]' ')
            }
            else
            {
                $this.empty.CopyTo($this.lines[$l],0)
            }
        }
    }
}
 
Class Game
{
    [System.Collections.Generic.List[ScreenObject]]$screenObjects = [System.Collections.Generic.List[ScreenObject]]::new()
    [Player]$Player = [Player]::Instance()
    [bool]$GameOver = $false
    [int]$Score = 0
    [System.Diagnostics.Stopwatch]$timer = [System.Diagnostics.Stopwatch]::new()
    [int]$EnemiesAttacking = [System.Console]::WindowHeight
 
    static [Game]$theGame = [Game]::Instance()
    
    static [Game]Instance()
    {
        if ($null -eq [Game]::theGame)
        {
            [Game]::theGame = [Game]::new()
        }
        return [Game]::theGame
    }
 
    [void]Reset()
    {
        $this.GameOver = $false
        [Screen]::Instance().Reset()
        $this.Score=0
        $this.EnemiesAttacking = [System.Console]::WindowHeight
        $this.Player.Reset()
        $this.InitializeScreenObjects()
        $this.timer.Reset()
        $this.timer.Restart()
    }

    [void]InitializeScreenObjects()
    {
        [Screen]::Instance().Reset()
        $this.screenObjects.Clear()
        $this.AddEnemies($this.EnemiesAttacking)
    }
 
    [void]AddEnemies([int]$count)
    {
        
        for ($i =0;$i -lt $count; $i++)
        {
            [Enemy]$enemy = [Enemy]::new()
            $this.screenObjects.Add($enemy)
        }
    }
 
    [void]Start()
    {
        $this.Reset()
    }
 
    [void]Update()
    {
        for ($i = $this.screenObjects.Count -1; $i -ge 0; $i--)
        {
            $this.screenObjects[$i].Update()
        }
    }
 
    [void]Draw()
    {
        [Screen]::Instance().Reset()
        foreach ($obj in $this.screenObjects)
        {
            $obj.Draw()
        }
        [Player]::Instance().Draw()
        [Console]::SetCursorPosition(0,1)
        for ($curLine = 1;$curLine -lt [System.Console]::WindowHeight;$curLine++)
        {
            [Console]::Write([Screen]::Instance().lines[$curLine])
        }
        [Display]::Instance().Draw()
    }
}

$UseAsyncKeyState = $false
if (($IsWindows -eq $true) -or ($PSVersionTable.PSVersion.Major -le 5))
{
    $Signature = '[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] public static extern short GetAsyncKeyState(int virtualKeyCode);'
    Add-Type -MemberDefinition $Signature -Name Keyboard -Namespace AlienInvasion
    $UseAsyncKeyState = $true
    enum InputKeys
    {
        LeftArrow = 37
        RightArrow = 39
        Spacebar = 32
        Q = 81
    }
 
}
 
$Global:Random = [System.Random]::new()
 
Clear-Host
[Console]::CursorVisible = $false
 
$Game = [Game]::Instance()
$Game.Start()
 
while (-not $Game.GameOver)
{
 
    $Game.Update()
 
    if ($UseAsyncKeyState)
    {
        $pressedKeys = @(switch([InputKeys].GetEnumValues())
        {
            {[AlienInvasion.Keyboard]::GetAsyncKeyState([int]$_) -ne 0}{[int]$_}
        })
        if ([int][InputKeys]::Q -in $pressedKeys)
        {
            $Game.GameOver -eq $true
            break
        }
        else
        {
            $Game.Player.Update($pressedKeys)
        }
 
    }
    elseif (-not $UseAsyncKeyState)
    {
        #If the user is pressing a key
        if ([Console]::KeyAvailable)
        {
            $key = [Console]::ReadKey($true)

            while ([System.Console]::KeyAvailable)
            {
                $null = [Console]::ReadKey($true)
            }
 
            if ($key.Key -eq [System.ConsoleKey]::LeftArrow -or $key.Key -eq [System.ConsoleKey]::RightArrow -or $key.Key -eq [System.ConsoleKey]::Spacebar)
            {
                $Game.Player.Update(@([int]$key.Key))
            }
 
            elseif ($key.Key -eq [System.ConsoleKey]::Q)
            {
                $Game.GameOver = $true
            }
        }
    }
 
    $Game.Draw()
 
    [System.Threading.Thread]::Sleep(1000/30)
 
}
 
while ([Console]::KeyAvailable)
{
    $null = [Console]::ReadKey($true)   
}
 
Clear-Host
Write-Host "Final Score: $($Game.Score)"
Write-Host "Total Bombs used: $($Game.Player.UsedBombs)"
[Console]::WriteLine("Survival time: {0:mm\:ss\.fff}",$Game.timer.Elapsed)
$Game.Reset()