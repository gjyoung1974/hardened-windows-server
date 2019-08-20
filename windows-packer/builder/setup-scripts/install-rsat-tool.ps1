# 2019 - acme - Infrastructure Security Team
# Install the Remote Server Administration Tools (RSAT):
Install-WindowsFeature RSAT-DNS-Server -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature RSAT-AD-Tools -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature GPMC -IncludeAllSubFeature -IncludeManagementTools
