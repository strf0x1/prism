param(
    [string]$SysmonPath = "C:\vagrant_data\sysmon64.exe",
    [string]$WinLogBeatInstallerPath = "C:\vagrant_data\winlogbeat-7.17.20-windows-x86_64.msi",
    [string]$WinLogBeatConfigPath = "C:\vagrant_data\winlogbeat.yml"
)

# Sysmon Installation (from previous script)
$SysmonService = Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue

if ($null -eq $SysmonService) {
    Write-Host "Sysmon is not installed. Installing now..."
    if (Test-Path $SysmonPath) {
        Start-Process -FilePath $SysmonPath -ArgumentList "-accepteula -i" -Wait
        Write-Host "Sysmon installed successfully."
    } else {
        Write-Host "Error: Sysmon executable not found at $SysmonPath."
        exit 1
    }
} else {
    Write-Host "Sysmon is already installed."
}

# Create Sysmon scheduled task (from previous script)
$Action = New-ScheduledTaskAction -Execute "C:\Windows\Sysmon64.exe"
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

$Task = Get-ScheduledTask -TaskName "Start Sysmon" -ErrorAction SilentlyContinue

if ($null -eq $Task) {
    Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -TaskName "Start Sysmon" -Description "Starts Sysmon on boot"
    Write-Host "Scheduled task created to start Sysmon on boot."
} else {
    Write-Host "Scheduled task to start Sysmon already exists."
}

# WinLogBeat Installation
if (!(Test-Path $WinLogBeatInstallerPath)) {
    Write-Host "Error: WinLogBeat installer not found at $WinLogBeatInstallerPath."
    exit 1
}

Write-Host "Installing WinLogBeat..."
Start-Process msiexec.exe -ArgumentList "/i `"$WinLogBeatInstallerPath`" /qn" -Wait
Write-Host "WinLogBeat installed successfully."

# Copy WinLogBeat configuration
$WinLogBeatConfigDest = "C:\ProgramData\Elastic\Beats\winlogbeat\winlogbeat.yml"
if (Test-Path $WinLogBeatConfigPath) {
    Copy-Item -Path $WinLogBeatConfigPath -Destination $WinLogBeatConfigDest -Force
    Write-Host "WinLogBeat configuration copied to $WinLogBeatConfigDest"
} else {
    Write-Host "Error: WinLogBeat configuration not found at $WinLogBeatConfigPath."
    exit 1
}

# Start WinLogBeat service
$WinLogBeatService = Get-Service -Name winlogbeat -ErrorAction SilentlyContinue
if ($null -ne $WinLogBeatService) {
    if ($WinLogBeatService.Status -ne 'Running') {
        Start-Service -Name winlogbeat
        Write-Host "WinLogBeat service started."
    } else {
        Write-Host "WinLogBeat service is already running."
    }
} else {
    Write-Host "Error: WinLogBeat service not found. Installation may have failed."
    exit 1
}

Write-Host "Setup complete."