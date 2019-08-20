# 2019 - acme - Infrastructure Security Team
# Join the RSAT workstation to Active Directory
[string]$AdminUser = $args[0]
[string]$AdminPassword = $args[1]
[string]$DomainName = $args[2]
[string]$sDNS1 = $args[3]
[string]$sDNS2 = $args[4]
[string]$sDNS0 = $args[5]

# Set RSAT Workstation's DNS Entries
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS0 index=0 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS1 index=1 validate=no"
Invoke-Expression -Command:"netsh interface ip add dnsservers ""Ethernet"" $sDNS2 index=2 validate=no"

# Prepare our AD credentials:
$SecurePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($AdminUser, $SecurePassword)

# Join the domain
Add-Computer -domainname $DomainName -Credential $credentials -force

# Remove IPV6 from all interfaces:
Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6 -PassThru
