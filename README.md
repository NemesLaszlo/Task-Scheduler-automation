# Task-Scheduler-automation

The repository contains three powershell scripts. One of them registers a scheduled task to run at startup with delay (starts a docker container), another removes the scheduled task and the related docker container and image. Plus a simple running script.

### About the files

- 'application-task-scheduler.ps1' - Creates a task in the task scheduler than starts the application's docker container
  with a delay of 1 minute after the machine startup. It is necessary to run the docker application
  on the server machine to make sure the scheduled task can successfully start the dockerized application.

- 'application-task-scheduler-uninstall.ps1' - Completely deletes the application.
  The scheduled task and the image file of the application and the container of the
  application within docker will also be deleted.

- 'application-run.ps1' - Starts the dockerized application with the configuration
  from the mounted 'configuration' file in the folder.
