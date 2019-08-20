# 2019 - acme - Infrastructure Security Team
# This script Installs Python

# Fetch & install Python for Windows
function Install-Python {
    Write-Host 'Starting install-python.ps1'
    (New-Object Net.WebClient).DownloadFile("https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi", "C:\\Windows\\builder\\python-2.7.16.amd64.msi")
    (Start-Process "msiexec.exe" -ArgumentList "/i C:\\Windows\\builder\\python-2.7.16.amd64.msi ALLUSERS=1 /quiet" -NoNewWindow -Wait -PassThru)
}

# Main script section:
Install-Python
Write-Host 'Finishing install-python.ps1'
