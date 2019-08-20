# 2019 - acme - Infrastructure Security Team
# Install OpenSSH Service and tools
function Install-OpenSSH {
    Write-Host 'Starting install-openssh.ps1'
    Get-WindowsCapability -Name OpenSSH.Server* -Online | Add-WindowsCapability -Online
}

# Configure OpenSSH
function Install-OpenSSH-Tools {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Set-Service -Name sshd -StartupType 'Automatic'
    Set-Service -Name ssh-agent -StartupType 'Automatic'
    Start-Service sshd
    Start-Service ssh-agent
    Install-Module -Force OpenSSHUtils -Scope AllUsers
    Start-Service ssh-agent
    Set-Service -Name ssh-agent -StartupType 'Automatic'
    Write-Host 'Finishing install-openssh.ps1'
}

Write-Host 'Starting install-openssh.ps1'
Install-OpenSSH
Install-OpenSSH-Tools
Write-Host 'Finishing install-openssh.ps1'
