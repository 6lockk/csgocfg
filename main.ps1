$refreshRate = Read-Host "Please enter your monitor's refresh rate:"

$launchOptions = "-novid -tickrate 128 +mat_queue_mode 2 +cl_forcepreload 1 -novid -nojoy -nopreload -full +mat_disable_fancy_blending 1 +fps_max 0 +cl_forcepreload 1 -nojoy -softparticlesdefaultoff -nohltv +violence_hblood 0 +r_dynamic 1 -no-browser -limitvs -freq $refreshRate"

Set-Clipboard $launchOptions

Write-Host "Launch options copied to clipboard."

$csgoExe = [System.Windows.Forms.OpenFileDialog]::new()
$csgoExe.Title = "Select the csgo.exe file"
$csgoExe.Filter = "Executable files (*.exe)|*.exe"
$csgoExe.Multiselect = $false
$csgoExe.InitialDirectory = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ProgramFilesX86)
$dialogResult = $csgoExe.ShowDialog()

if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $processPath = $csgoExe.FileName

    Write-Host "csgo.exe found at $processPath."
    $processName = "csgo"
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
        Write-Host "Process priority set to High."
    }
    else {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $processPath
        $startInfo.WorkingDirectory = Split-Path $processPath
        $startInfo.Arguments = $launchOptions
        $startInfo.UseShellExecute = $false
        [System.Diagnostics.Process]::Start($startInfo) | Out-Null
        Write-Host "CS:GO launched with launch options and process priority set to High."
    }
}
else {
    Write-Host "csgo.exe is not running."
}

}
