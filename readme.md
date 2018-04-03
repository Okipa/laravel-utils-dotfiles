# Laravel utils dotfiles

## Installation
- install the dotfiles in your project with the following command : `git submodule add git@github.com:Okipa/laravel-utils-dotfiles.git .utils`.
- copy the following command from the root path of your project  : `cp -R .utils/.utils.custom .utils.custom`

### .utils/docker/
- up.sh : start the project laradock docker containers
    > | Option | Description |
    > |---|---|
    > | --build | Customize the .env, the dockerfiles and the docker-compose files |
    > | --proxy | Configure the nginx-proxy reverse proxy |
- stop.sh : stop the project laradock docker containers.
- workspace.sh : shortcut to get a ssh access to the laradock workspace with the `laradock` user.
    > | Option | Description |
    > |---|---|
    > | --root | Access to the docker laradock workspace with the `root` user |
- buildProjectConfig.sh : .env, dockerfiles and docker-compose files customization script.
- buildDinghyNginxProxyConfig.sh : nginx-proxy reverse proxy project configuration.

### .utils/git/
- submodulesInstallOrUpdate.sh : install or update all the project git submodules.

### .utils/helpers/
- checkVariableIsDefined.sh : check that the environment variable given in parameter is defined.
- checkFileExists.sh : check that the file path given in parameter exists.
- exportEnvFileVariables.sh : export the laravel environment variables for a bash use.
- loadScriptingColors.sh : load the bash scripting colors.
- requiresSudoRights.sh : check that a user with sudo rights is used.

### .utils/project/
- install.sh : execute all the project installation tasks.

### .utils/server/
- configCheck.sh : check that the server has the required dependencies.
- localesInstall.sh : install the project needed locales.

### .utils/supervisor/
- install.sh : configure and launch the project supervisor runners.
- restart.sh : restart the project supervisor runners.

## Adding instructions to dotfiles
Several dotfiles have to execute custom instructions related to your project needs.  
These instructions will have to be specified in the `.utils.custom` directory dotfiles.    
This way, your custom instructions will be synchronized with your project git repository where the content of `.utils/` can be fully destroy as it is a git submodule.

The following dotfiles that are eligible for custom instructions :

| Dotfile | Method | Custom instructions dotfile |
|---|---|---|---|
| .utils/project/install.sh | - | .utils.custom/project/install.sh : add custom instructions at the end of the script |
| .utils/server/configCheck.sh | - | .utils.custom/server/configCheck.sh : set the packages installations to check |
| .utils/server/localesInstall.sh | - | .utils.custom/server/localesInstall.sh : install the needed project locales |
| .utils/docker/buildProjectConfig.sh | setEnvVariables() | .utils.custom/docker/setEnvVariables.sh : replace the laradock .env default key / values |
| .utils/docker/buildProjectConfig.sh | customizeContainers() | .utils.custom/docker/customizeContainers.sh : customize laradock containers builds files |
| .utils/docker/buildProjectConfig.sh | customizeDockerComposeFile() | .utils.custom/docker/customizeDockerComposeFile.sh : customize laradock docker-compose.yml file |
| .utils/docker/buildProjectConfig.sh | setNginxConfig() | .utils.custom/docker/setNginxConfig.sh : set your project docker nginx configuration |
