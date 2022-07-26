If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script`nPlease re-run this script as an Administrator"
    Read-Host -Prompt "Press Enter to exit"
    Break
}

$TaskName = $(TaskName) 
$ImageName = $(DokcerImage)

# Stop and Delete scheduled task
if ($(Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue).TaskName -eq $TaskName) {
    Write-Host "Removing task: $TaskName from the Task scheduler"
    Stop-ScheduledTask -TaskName $TaskName
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$False
    Write-Host "Task: $TaskName was removed successful from the Task scheduler"

    # Stop and remove the container, then remove the image as well
    Write-Host "Stopping and Removing the docker container of the scheduled task"
    docker rm $(docker stop $(docker ps -a -q --filter ancestor=$ImageName --format="{{.ID}}"))
    docker rmi $ImageName
    Write-Host "Stop and Remove was successful of the docker container of the scheduled task"
}