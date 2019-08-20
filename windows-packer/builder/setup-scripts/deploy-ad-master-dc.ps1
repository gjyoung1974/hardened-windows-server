# 2019 - acme - Infrastructure Security Team
# Deploy our first AD Domain Controller (new DC in a new forest)
[string]$sSafeModeAdministratorPassword = $args[0]
[string]$sDomainName = $args[1]
[string]$sDomainNetbiosName = $args[2]
[string]$sDNS1 = $args[3]
[string]$sDNS2 = $args[4]
[string]$sDNS0 = $args[5]
[string]$sDomainMode = $args[6]
[string]$sForestMode = $args[7]

# Install the AD-Domain-Services windows feature
Install-windowsfeature -name AD-Domain-Services -Restart:$false

# Prepare our GCE Persistent Volume that hosts the NTDS/DIT/Sysvol data
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize -IsActive -DriveLetter D
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel NTDS

# Install the first  domain controller in the forest
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "D:\NTDS" -DomainMode $sDomainMode -DomainName $sDomainName -DomainNetbiosName $sDomainNetbiosName -ForestMode $sForestMode -InstallDns:$true -LogPath "D:\NTDS" -SysvolPath "D:\SYSVOL" -NoRebootOnCompletion:$true -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString $sSafeModeAdministratorPassword -AsPlainText -Force)

# Set DNS Entries
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS0 index=0 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS1 index=1 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS2 index=2 validate=no"

# Remove IPV6 from all interfaces:
Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -PassThru
