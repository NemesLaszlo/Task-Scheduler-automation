If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script`nPlease re-run this script as an Administrator"
    Read-Host -Prompt "Press Enter to exit"
    Break
}

$TaskName = $(TaskName)
$Description = $(Description)
$DockerImage = $(DockerImage) 

# New scheduled task to run docker application
# For example in dotnet application configuration file is the appsettings.json
$Action = New-ScheduledTaskAction -Execute 'docker' -Argument "run -p 80:80 --mount type=bind,source=$pwd\[configuration_file],target=\app\[configuration_file] $DockerImage"

# Scheduled task trigger - run at startup, but with 1 minute delay
$Trigger = New-ScheduledTaskTrigger -RandomDelay (New-TimeSpan -Minutes 1) -AtStartup

# Settings
# Not stop when the idle ends
# Setting the restart interval to 1 minute
# Setting the reset count to 10 tries
# starting when available
# Removing the idle timeout option
$Settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -RestartInterval (New-TimeSpan -Minutes 1) -RestartCount 10 -StartWhenAvailable
$Settings.ExecutionTimeLimit = "PT0S"

# Task running credentials
$msg = "Enter the Administrator username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password", $msg, "$env:userdomain\$env:username", $env:userdomain)
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password

# Register scheduled task
Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -User $username -Password $password -Settings $settings -Description $Description


Read-Host -Prompt "Press Enter to exit"