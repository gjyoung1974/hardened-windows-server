# 2019 - acme - Infrastructure Security Team
# This script Installs stackdriver monitoring and Prometheus metric exporter agents

# Install the GCP StackDriver agent
# https://cloud.google.com/logging/docs/agent/installation#agent-install-windows
function Install-StackdriverLogging {
    Write-Host 'Installing StackDriver agent'
    (New-Object Net.WebClient).DownloadFile("https://dl.google.com/cloudagents/windows/StackdriverLogging-v1-9.exe", "C:\\Windows\\builder\\StackdriverLogging-v1-9.exe")
    Start-Process -FilePath "C:\\Windows\\builder\\StackdriverLogging-v1-9.exe" -ArgumentList "/S" -PassThru -wait
}

# Install Windows Prometheus WMI exporter for Windows
function Install-Prometheus-Exporter {
    Write-Host 'Installing Prometheus WMI Exporter'
    (New-Object Net.WebClient).DownloadFile("https://github.com/martinlindhe/wmi_exporter/releases/download/v0.7.0/wmi_exporter-0.7.0-amd64.msi", "C:\\Windows\\builder\\wmi_exporter-0.7.0-amd64.msi")
    (Start-Process "msiexec.exe" -ArgumentList "/i C:\\Windows\\builder\\wmi_exporter-0.7.0-amd64.msi ENABLED_COLLECTORS=ad,cpu,cs,dns,logical_disk,memory,net,os,process,service,system,tcp INSTALLDIR=""C:\Program Files\wmi_exporter\"" /quiet" -NoNewWindow -Wait -PassThru)
}

# Main script section:
Write-Host 'Starting logging-and-monitoring.ps1'
Install-StackdriverLogging
Install-Prometheus-Exporter
Write-Host 'Finishing logging-and-monitoring.ps1'
