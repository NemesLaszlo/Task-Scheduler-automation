If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script`nPlease re-run this script as an Administrator"
    Read-Host -Prompt "Press Enter to exit"
    Break
}

$DockerImage = $(DokcerImage)

# For example in dotnet application configuration file is the appsettings.json
docker run -p 80:80 --mount type=bind, source=$pwd\[configuration_file], target=/app/[configuration_file] $DockerImage