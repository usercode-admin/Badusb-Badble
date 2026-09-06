# === BADUSB TROLL - BẢN FULL TÍNH NĂNG ===

# 1. TẢI ẢNH
$url1 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main.png'
$url2 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main2.png'

$save1 = "$env:USERPROFILE\Pictures\main.png"
$save2 = "$env:USERPROFILE\Pictures\main2.png"
$temp1 = "$env:TEMP\temp1.png"
$temp2 = "$env:TEMP\temp2.png"

try {
    Invoke-WebRequest -Uri $url1 -OutFile $temp1 -UseBasicParsing
    Invoke-WebRequest -Uri $url2 -OutFile $temp2 -UseBasicParsing
} catch {
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap(1920, 1080)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Green)
    $font = New-Object System.Drawing.Font("Arial", 80)
    $g.DrawString("BADUSB", $font, [System.Drawing.Brushes]::White, 700, 400)
    $bmp.Save($temp1, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $g.Dispose()
    Copy-Item $temp1 $temp2 -Force
}

# 2. XỬ LÝ TRÙNG TÊN
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

# 3. SET WALLPAPER
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
namespace Win32 {
    public class Wp {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
}
'@ -ErrorAction SilentlyContinue

[Win32.Wp]::SystemParametersInfo(20, 0, $save1, 3)

# 4. LOAD ẢNH VÀO BỘ NHỚ
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$img1 = [System.Drawing.Image]::FromFile($save1)
$img2 = [System.Drawing.Image]::FromFile($save2)

if (-not $img1) {
    $bmp = New-Object System.Drawing.Bitmap(400, 500)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Red)
    $img1 = $bmp
}
if (-not $img2) {
    $bmp = New-Object System.Drawing.Bitmap(400, 500)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Blue)
    $img2 = $bmp
}

# ==== 5. HIỂN THỊ BẢNG "HELLO WORLD" Ở GIỮA MÀN HÌNH ====
$labelForm = New-Object System.Windows.Forms.Form
$labelForm.FormBorderStyle = 'None'
$labelForm.StartPosition = 'CenterScreen'  # Nằm chính giữa màn hình
$labelForm.Width = 600
$labelForm.Height = 300
$labelForm.BackColor = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)  # Nền trong suốt
$labelForm.TopMost = $true
$labelForm.ControlBox = $false

$label = New-Object System.Windows.Forms.Label
$label.Text = "Hello world"
$label.Font = New-Object System.Drawing.Font("Arial", 72, [System.Drawing.FontStyle]::Bold)
$label.ForeColor = [System.Drawing.Color]::White
$label.BackColor = [System.Drawing.Color]::FromArgb(128, 0, 0, 0)  # Nền đen mờ
$label.AutoSize = $false
$label.Width = 600
$label.Height = 300
$label.TextAlign = 'MiddleCenter'
$label.Dock = 'Fill'

$labelForm.Controls.Add($label)
$labelForm.Show()

# ==== 6. TẠO POPUP ẢNH ====
$scr = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

for ($i = 0; $i -lt 15; $i++) {
    $f = New-Object System.Windows.Forms.Form
    $f.FormBorderStyle = 'None'
    $f.StartPosition = 'Manual'
    $f.Width = 400
    $f.Height = 500
    $f.Left = (Get-Random -Min 0 -Max ($scr.Width - 400))
    $f.Top = (Get-Random -Min 0 -Max ($scr.Height - 500))
    $f.TopMost = $true

    $pb = New-Object System.Windows.Forms.PictureBox
    $pb.Dock = 'Fill'
    if ((Get-Random -Min 1 -Max 3) -eq 1) {
        $pb.Image = $img1.Clone()
    } else {
        $pb.Image = $img2.Clone()
    }
    $pb.SizeMode = 'Zoom'
    $f.Controls.Add($pb)
    $f.Show()
    Start-Sleep -Milliseconds 100
}

# 7. GIỮ TẤT CẢ CỬA SỔ
while ($true) { Start-Sleep 1 }
