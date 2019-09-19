# Windows Server Hardening

## Pack a Microsoft© Windows Server©, apply customizations and security baseline hardening        

Vulnerability management CI flow:    
![CICD Flow](./docs/cicd-flow.png)

This is an automation of the work provided © Microsoft
[Security-baseline-FINAL-for-Windows-10-v1809-and-Windows-Server](https://techcommunity.microsoft.com/t5/Microsoft-Security-Baselines/Security-baseline-FINAL-for-Windows-10-v1809-and-Windows-Server/ba-p/701082)    

### How is this run? See the [.drone.yml](.drone.yml) job section

### The core of the automation is
1. **A Bash shell Script:** https://github.com/gjyoung1974/hardened-windows-server/blob/master/windows-packer/build.sh
2. **The Packer script:** https://github.com/gjyoung1974/hardened-windows-server/blob/master/windows-packer/gcp_hardened_windows_server.json
3. **Windows Automation scripting** Which applies Windows "Security Hardening" GPOS to the instance: https://github.com/gjyoung1974/hardened-windows-server/blob/master/windows-packer/builder/benchmark-gpos/Local_Script/BaselineLocalInstall.ps1

The basic flow is:
1. The **CI pipeline** ".drone.yml" calls ./windows-packer/build.sh << in this case we are using Drone.io << (Is portable to whatever Docker based CICD tooling you require)    
2. **`build.sh`** (a) sets environment variables, (b) performs some utility functions     
3. **`build.sh`** then runs "$ packer build ./windows-packer/gcp_hardened_windows_server.json"     
4.  The **packer "script"** (json config) pushes & executes several Windows automation scripts (powershell & others)
    - The windows automation scripts are located in ./builder/setup-scripts    
5. **Sysprep:** The final thing packer executes is Windows Sysprep, not one we provide, but the sysprep configuuration that is "baked" into the GCP source image.    

### QEMU Example
For the sake of giving a simplified example, a QEMU packer builder script is included.    
- See [./windows-packer/gcp_hardened_windows_server.json](./windows-packer/gcp_hardened_windows_server.json)    
- The qemu builder script allows you to run the packer locally on a *nix machine (Mac/Linux) with [QEMU](https://www.qemu.org/) installed     
- Building locally allows you to observe the workflow without the complexity of CICD and the cloud provider
- Save time and debugging effort by testing things locally     

### GCP Environment Variables:

`ENV ADMIN_PWD_CIPHERTEXT`    
### Encrypt a string using a KMS Key shared with the service account running this build

`ENV ARTIFACT_BUCKET`     
#### Share a GCS storage bucket with the service account running this build

`ENV GCLOUD_SERVICE_KEY`     
#### Provide the JSON format Service account as a string as an environment variable for authentication     

`ENV GOOGLE_APPLICATION_CREDENTIALS`     
#### Provide the path the the aformentioned service account JSON file within the docker container for your build system.     
#### for Drone.io CI it's typically /drone/src/drone.json     

`ENV GOOGLE_COMPUTE_ZONE`     
#### The zone in which your compute resources lie in.     

`ENV GOOGLE_PROJECT_ID`     
#### The GCloud project ID     

`ENV GCP_NETWORK_ID`     
#### Use a custom (vs the default) network     

`ENV GCP_SUBNET_ID`     
#### Provide the custom subnet ID     

`ENV SECRETS_KEYRING`     
`ENV SECRETS_KEY`     
#### Share a Key with the service account running this build.     
#### We use a KMS key to share secrets between the image builder and secrets storage in the cloud.     

---

2019 gjyoung1974@gmail.com
