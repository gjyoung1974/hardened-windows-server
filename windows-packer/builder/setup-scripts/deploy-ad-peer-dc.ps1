# 2019 - acme - Infrastructure Security Team
# Deploy a peer DC Domain Controller to an existing forest
[string]$AdminUser = $args[0]
[string]$AdminPassword = $args[1]
[string]$sSafeModePasswd = $args[2]
[string]$sDomainName = $args[3]
[string]$sDNS1 = $args[4]
[string]$sDNS2 = $args[5]
[string]$sDNS0 = $args[6]

# Set DNS Entries
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS0 index=0 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS1 index=1 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS2 index=2 validate=no"

# Install the AD-Domain-Services windows feature
Install-windowsfeature -name AD-Domain-Services -Restart:$false

# Prepare our GCE Persistent Volume that hosts the NTDS/DIT/Sysvol data
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize -IsActive -DriveLetter D
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel NTDS

# prepare our AD credentials
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($AdminUser, $SecurePassword)
$safeModePasswd = ConvertTo-SecureString $sSafeModePasswd -AsPlainText -Force

# Add peer DC to an existing forest
Install-ADDSDomainController -Credential $credentials -CreateDnsDelegation:$false -DatabasePath "D:\NTDS" -DomainName $sDomainName -InstallDns:$true -LogPath "D:\NTDS" -NoGlobalCatalog:$false -SiteName "Default-First-Site-Name" -SysvolPath "D:\SYSVOL" -Force:$true -SafeModeAdministratorPassword $safeModePasswd

# Remove IPV6 from all interfaces:
Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -PassThru
