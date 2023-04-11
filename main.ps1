# Prompt user to select CSGO executable
$title = "Select CSGO Executable"
$filter = "csgo.exe|csgo.exe"
$gamePath = [System.IO.Path]::GetDirectoryName((New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles)
    Title = $title
    Filter = $filter
}).ShowDialog())

# Set best launch options for CSGO
$launchOptions = "-novid -tickrate 128 +mat_queue_mode 2 +cl_forcepreload 1 -nojoy -nod3d9ex1 -high -nopreload -full +mat_disable_fancy_blending 1 +fps_max 0 +cl_forcepreload 1 -nojoy -softparticlesdefaultoff -nohltv +violence_hblood 0 +r_dynamic 1 -no-browser -limitvs-threads $(Get-WmiObject Win32_Processor | select MaxClockSpeed).0 -refresh 144"

# Prompt user for refresh rate
$refreshRate = Read-Host "Enter your preferred refresh rate (default: 144)"

# If refresh rate is specified, add it to the launch options
if ($refreshRate) {
    $launchOptions += " -freq $refreshRate"
}

# Prompt user for process priority
$priority = Read-Host "Enter the priority level for CSGO process (default: Normal)"

# If priority is specified, set the process priority
if ($priority) {
    switch ($priority.ToLower()) {
        "normal" {
            $priorityLevel = "Normal"
            break
        }
        "high" {
            $priorityLevel = "High"
            break
        }
        "realtime" {
            $priorityLevel = "RealTime"
            break
        }
        default {
            $priorityLevel = "Normal"
            Write-Host "Invalid priority level, using default: Normal"
        }
    }
}

# Start CSGO process with specified launch options and priority level
$process = Start-Process -FilePath "$gamePath\csgo.exe" -ArgumentList $launchOptions -Wait -NoNewWindow -PassThru
if ($priorityLevel) {
    $process.PriorityClass = $priorityLevel
}

# Set launch options in CSGO properties
$gameProps = Get-ItemProperty -Path "HKCU:\Software\Valve\Steam\Apps\730"
$gameProps.SteamAppLaunchOptions = $launchOptions
Set-ItemProperty -Path "HKCU:\Software\Valve\Steam\Apps\730" -Name "SteamAppLaunchOptions" -Value $launchOptions

# Show launch options and priority level to user
Write-Host "CSGO launch options set to: $launchOptions"
Write-Host "CSGO process priority set to: $priorityLevel"
