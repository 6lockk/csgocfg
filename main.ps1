$refreshRate = Read-Host "Please enter your monitor's refresh rate:"
$csgoPath = Read-Host "Please enter the full path to your CS:GO installation folder:"

$launchOptions = "-novid -tickrate 128 +mat_queue_mode 2 +cl_forcepreload 1 -novid -nojoy -nopreload -full +mat_disable_fancy_blending 1 +fps_max 0 +cl_forcepreload 1 -nojoy -softparticlesdefaultoff -nohltv +violence_hblood 0 +r_dynamic 1 -no-browser -limitvs -freq $refreshRate"

Write-Host "Launch options with your refresh rate included:`n$launchOptions"

Set-Clipboard $launchOptions

Write-Host "Launch options copied to clipboard."

$processName = "csgo"
$processPath = "$csgoPath\csgo.exe"

if (Test-Path $processPath) {
    Write-Host "CS:GO found at $processPath. Setting process priority to high."
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
        Write-Host "Process priority set to High."
    }
    else {
        Write-Host "CS:GO process not found."
    }
}
else {
    Write-Host "CS:GO not found at $processPath."
}
