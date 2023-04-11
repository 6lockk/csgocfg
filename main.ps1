# Prompt user to select CSGO executable
$title = "Select CSGO Executable"
$filter = "csgo.exe|csgo.exe"
$gamePath = [System.IO.Path]::GetDirectoryName((New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)
    Title = $title
    Filter = $filter
}).ShowDialog())

# Set best launch options for CSGO
$launchOptions = "-novid -tickrate 128 -nojoy -nod3d9ex1 +mat_queue_mode 2 +cl_forcepreload 1 -novid -nojoy -nopreload -full +mat_disable_fancy_blending 1 +fps_max 0 +cl_forcepreload 1 -nojoy -softparticlesdefaultoff -nohltv +violence_hblood 0 +r_dynamic 1 -no-browser -limitvs-high -threads $(Get-WmiObject Win32_Processor | select MaxClockSpeed).0 -refresh 144"

# Prompt user for refresh rate
$refreshRate = Read-Host "Enter your preferred refresh rate (default: 144)"

# If refresh rate is specified, add it to the launch options
if ($refreshRate) {
    $launchOptions += " -freq $refreshRate"
}

# Set launch options in CSGO properties
$gameProps = Get-ItemProperty -Path "HKCU:\Software\Valve\Steam\Apps\730"
$gameProps.SteamAppLaunchOptions = $launchOptions
Set-ItemProperty -Path "HKCU:\Software\Valve\Steam\Apps\730" -Name "SteamAppLaunchOptions" -Value $launchOptions

# Show launch options to user
Write-Host "CSGO launch options set to: $launchOptions"
