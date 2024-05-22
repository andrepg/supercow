Hi there! 👋 Welcome to **Supercow**, a collection of useful scripts that I collected along my TI career.

Everybody has some common problems once in a while that could be easily achieved with some sort of script, or some *snippet* that we found in the internet. Well, this is my personal collection. Some of them are infra-related. Others can be installation scripts or even some sort of dumb automation. 

**🆓 And you're free to use it and copy all !**

## 👀 Checkout our scripts index

### Laravel deployment
🌐 [deploy_laravel_application.sh](https://github.com/andrepg/supercow/blob/main/deploy_laravel_application.sh)

This is a fancy interactive script to clone a repository using GitHub Client library. Besides that, it has a lot of nice scripts that you can take a look to fast build pre-deployment on CI. 

This script is also capable of run NPM building jobs and uses RSync as main mechanism to upload files to remote server. All required information will be asked during the process.

### Dolibarr automatic update
🌐 [update_dolibarr_installation.sh](https://github.com/andrepg/supercow/blob/main/update_dolibarr_installation.sh)

A simple script that receives a Dolibarr version as argument and downloads from official GitHub repository this snapshot. 

Once it has cloned, it will replace your $PUBLIC_PATH files with the ones downloaded using RSync. The sync process is incremental and verbose, you should see all progress and follow the journey. 😄

### Change published name on Windows Server Remote Desktop
🌐 [set_published_name_remote_desktop_winserver.ps1](https://github.com/andrepg/supercow/blob/main/set_published_name_remote_desktop_winserver.ps1)

Honestly, this is a stolen script, but I don't know from where anymore. Could happily give credits if knowing to whom. Whatever. It's a PowerShell script to change Remote Desktop Server Name on Windows. 

It's kinda a very specific feature to companies that used WebRDP at the time and wanted a custom name showed. This was the way that I found to make this process automatic when deploying a new virtual machine. 
