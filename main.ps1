# === BADUSB TROLL - BẢN MƯỢT MÀ ===

# 1. KIỂM TRA INTERNET TRƯỚC
try {
    $test = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com' -UseBasicParsing -TimeoutSec 3
    Write-Host "[OK] Co internet" -ForegroundColor Green
} catch {
    Write-Host "[LOI] Khong co internet! Thoat..." -ForegroundColor Red
    Read-Host "Nhan Enter de thoat"
    exit
}

# 2. TẢI ẢNH VỀ (có kiểm tra lỗi)
$url1 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main.png'
$url2 = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main2.png'

$save1 = "$env:USERPROFILE\Pictures\main.png"
$save2 = "$env:USERPROFILE\Pictures\main2.png"
$temp1 = "$env:TEMP\temp1.png"
$temp2 = "$env:TEMP\temp2.png"

Write-Host "[1] Dang tai anh 1..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url1 -OutFile $temp1 -UseBasicParsing
    Write-Host "[OK] Da tai anh 1" -ForegroundColor Green
} catch {
    Write-Host "[LOI] Tai anh 1 that bai: $_" -ForegroundColor Red
    # TẠO ẢNH DỰ PHÒNG NGAY LẬP TỨC
    Add-Type -AssemblyName System.Drawing
    $bmp = New-Object System.Drawing.Bitmap(1920, 1080)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::Blue)
    $font = New-Object System.Drawing.Font("Arial", 80)
    $g.DrawString("BADUSB", $font, [System.Drawing.Brushes]::White, 700, 400)
    $bmp.Save($temp1, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $g.Dispose()
    Write-Host "[OK] Da tao anh du phong" -ForegroundColor Green
}

Write-Host "[2] Dang tai anh 2..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url2 -OutFile $temp2 -UseBasicParsing
    Write-Host "[OK] Da tai anh 2" -ForegroundColor Green
} catch {
    Write-Host "[LOI] Tai anh 2 that bai, copy tu anh 1" -ForegroundColor Red
    Copy-Item $temp1 $temp2 -Force
}

# 3. XỬ LÝ TRÙNG TÊN (đổi tên thông minh)
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
Write-Host "[OK] Da luu anh tai: $save1" -ForegroundColor Green
Write-Host "[OK] Da luu anh tai: $save2" -ForegroundColor Green

# 4. SET WALLPAPER (kiểm tra file tồn tại trước)
if (Test-Path $save1) {
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
    Write-Host "[OK] Da set wallpaper!" -ForegroundColor Green
} else {
    Write-Host "[LOI] Khong tim thay anh de set wallpaper" -ForegroundColor Red
}

# 5. TẠO POPUP (mượt mà, không lag)
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$scr = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds

Write-Host "[3] Dang tao 15 popup..." -ForegroundColor Yellow
for ($i = 0; $i -lt 15; $i++) {
    $f = New-Object System.Windows.Forms.Form
    $f.FormBorderStyle = 'None'
    $f.StartPosition = 'Manual'
    $f.Width = 400
    $f.Height = 500
    $f.Left = (Get-Random -Min 0 -Max ($scr.Width - 400))
    $f.Top = (Get-Random -Min 0 -Max ($scr.Height - 500))
    $f.TopMost = $true  # Hiện trên cùng
    
    $pb = New-Object System.Windows.Forms.PictureBox
    $pb.Dock = 'Fill'
    # Chọn ảnh ngẫu nhiên
    if ((Get-Random -Min 1 -Max 3) -eq 1 -and (Test-Path $save1)) {
        $pb.ImageLocation = $save1
    } elseif (Test-Path $save2) {
        $pb.ImageLocation = $save2
    } else {
        $pb.BackColor = [System.Drawing.Color]::Red
    }
    $pb.SizeMode = 'Zoom'
    $f.Controls.Add($pb)
    $f.Show()
    Start-Sleep -Milliseconds 100  # Giảm delay để nhanh hơn
}

Write-Host "[OK] Da tao xong 15 popup!" -ForegroundColor Green
Write-Host "[4] Dang giu popup..." -ForegroundColor Yellow

# 6. GIỮ POPUP (có thể tắt bằng Alt+F4)
while ($true) { Start-Sleep 1 }
