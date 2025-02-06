Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Scrcpy Lazy GUI"
$form.Size = New-Object System.Drawing.Size(800, 600)
$form.StartPosition = "CenterScreen"

# Function to add a checkbox
function Add-Checkbox {
    param (
        [string]$Text,
        [int]$Left,
        [int]$Top
    )
    $checkbox = New-Object System.Windows.Forms.CheckBox
    $checkbox.Text = $Text
    $checkbox.Location = New-Object System.Drawing.Point($Left, $Top)
    $checkbox.AutoSize = $true
    $form.Controls.Add($checkbox)
    return $checkbox
}

# Function to add a label and textbox
function Add-Textbox {
    param (
        [string]$LabelText,
        [int]$Left,
        [int]$Top,
        [int]$Width = 100
    )
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $LabelText
    $label.Location = New-Object System.Drawing.Point($Left, $Top)
    $label.AutoSize = $true
    $form.Controls.Add($label)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Location = New-Object System.Drawing.Point(($Left + 120), $Top)
    $textbox.Size = New-Object System.Drawing.Size($Width, 20)
    $form.Controls.Add($textbox)
    return $textbox
}

# Add checkboxes for options (arranged side by side)
$fullscreenCheckbox = Add-Checkbox -Text "Fullscreen" -Left 20 -Top 20
$turnScreenOffCheckbox = Add-Checkbox -Text "Turn Screen Off" -Left 150 -Top 20
$stayAwakeCheckbox = Add-Checkbox -Text "Stay Awake" -Left 280 -Top 20
$noAudioCheckbox = Add-Checkbox -Text "No Audio" -Left 410 -Top 20
$showTouchesCheckbox = Add-Checkbox -Text "Show Touches" -Left 540 -Top 20
$disableScreensaverCheckbox = Add-Checkbox -Text "Disable Screensaver" -Left 20 -Top 50
$alwaysOnTopCheckbox = Add-Checkbox -Text "Always On Top" -Left 150 -Top 50
$windowBorderlessCheckbox = Add-Checkbox -Text "Window Borderless" -Left 280 -Top 50
$powerOffOnCloseCheckbox = Add-Checkbox -Text "Power Off on Close" -Left 410 -Top 50

# Add textboxes for additional options
$bitrateTextbox = Add-Textbox -LabelText "Bitrate (e.g., 2M):" -Left 20 -Top 90
$maxSizeTextbox = Add-Textbox -LabelText "Max Size (e.g., 1024):" -Left 20 -Top 120
$maxFpsTextbox = Add-Textbox -LabelText "Max FPS (e.g., 30):" -Left 20 -Top 150
$recordPathTextbox = Add-Textbox -LabelText "Record Path (e.g., file.mp4):" -Left 20 -Top 180 -Width 200
$serialTextbox = Add-Textbox -LabelText "Device Serial:" -Left 20 -Top 210 -Width 200
$windowTitleTextbox = Add-Textbox -LabelText "Window Title:" -Left 20 -Top 240 -Width 200
$cropTextbox = Add-Textbox -LabelText "Crop (e.g., 1200:800:100:100):" -Left 20 -Top 270 -Width 200
$pushTargetTextbox = Add-Textbox -LabelText "Push Target (e.g., /sdcard/):" -Left 20 -Top 300 -Width 200

# Run Button
$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = "Run Scrcpy"
$runButton.Location = New-Object System.Drawing.Point(20, 350)
$runButton.Size = New-Object System.Drawing.Size(100, 30)
$runButton.Add_Click({
    $scrcpyPath = "scrcpy.exe" # Path to scrcpy executable
    $arguments = @()

    # Add options based on checkboxes
    if ($fullscreenCheckbox.Checked) { $arguments += "--fullscreen" }
    if ($turnScreenOffCheckbox.Checked) { $arguments += "--turn-screen-off" }
    if ($stayAwakeCheckbox.Checked) { $arguments += "--stay-awake" }
    if ($noAudioCheckbox.Checked) { $arguments += "--no-audio" }
    if ($showTouchesCheckbox.Checked) { $arguments += "--show-touches" }
    if ($disableScreensaverCheckbox.Checked) { $arguments += "--disable-screensaver" }
    if ($alwaysOnTopCheckbox.Checked) { $arguments += "--always-on-top" }
    if ($windowBorderlessCheckbox.Checked) { $arguments += "--window-borderless" }
    if ($powerOffOnCloseCheckbox.Checked) { $arguments += "--power-off-on-close" }

    # Add options based on textboxes
    if ($bitrateTextbox.Text -ne "") { $arguments += "--bit-rate"; $arguments += $bitrateTextbox.Text }
    if ($maxSizeTextbox.Text -ne "") { $arguments += "--max-size"; $arguments += $maxSizeTextbox.Text }
    if ($maxFpsTextbox.Text -ne "") { $arguments += "--max-fps"; $arguments += $maxFpsTextbox.Text }
    if ($recordPathTextbox.Text -ne "") { $arguments += "--record"; $arguments += $recordPathTextbox.Text }
    if ($serialTextbox.Text -ne "") { $arguments += "--serial"; $arguments += $serialTextbox.Text }
    if ($windowTitleTextbox.Text -ne "") { $arguments += "--window-title"; $arguments += $windowTitleTextbox.Text }
    if ($cropTextbox.Text -ne "") { $arguments += "--crop"; $arguments += $cropTextbox.Text }
    if ($pushTargetTextbox.Text -ne "") { $arguments += "--push-target"; $arguments += $pushTargetTextbox.Text }

    # Run scrcpy with the selected options
    if ($arguments.Count -gt 0) {
        Start-Process -FilePath $scrcpyPath -ArgumentList $arguments
    } else {
        [System.Windows.Forms.MessageBox]::Show("No options selected. Please select at least one option.", "Error", "OK", "Error")
    }
})
$form.Controls.Add($runButton)

# Show the form
$form.ShowDialog()