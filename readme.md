# Laravel utils dotfiles

## Usage
- install the dotfiles in your project with the following command : `git submodule add git@github.com:Okipa/laravel-utils-dotfiles.git .utils`.

### .utils/docker/
- up.sh : start the project laradock docker containers
    > --build : customize the .env, the dockerfiles and the docker-compose files
    > --proxy : configure the nginx-proxy reverse proxy
- stop.sh : stop the project laradock docker containers.
- workspace.sh : shortcut to get a ssh access to the laradock workspace with the `laradock` user.
    > --root : access to the docker laradock workspace with the `root` user.
- buildProjectConfig.sh : .env, dockerfiles and docker-compose files customization script.
- buildDinghyNginxProxyConfig.sh : nginx-proxy reverse proxy project configuration.

### .utils/git/
- submodulesInstallOrUpdate.sh : install or update all the projet git submodules.

### .utils/helpers/
- checkVariableIsDefined.sh : check that the environment variable given in parameter is defined.
- checkFileExists.sh : check that the file path given in parameter exists.
- exportEnvFileVariables.sh : export the laravel environment variables for a bash use.
- requiresSudoRights.sh : check that the root user is used.

### .utils/project/
- projectInstall.sh : execute all the project installation tasks.

### .utils/server/
- configCheck.sh : check that the server has the required dependencies.
- localesInstall.sh : install the fr-FR and the en_GB locales (by default).

### .utils/supervisor/
- install.sh : configure and launch the project supervisor runners.
- restart.sh : restart the project supervisor runners.

## Adding instructions to dotfiles
Several dotfiles can execute custom instructions.  
To add instructions in the `.utils` dotfiles, just create dotfiles that take the exact same path in the `.utils.custom/` directory.  
Then, add your instructions in the created `custom` dotfiles.  
This way custom dotfiles will be synchronized with git where the content of `.utils/` can be fully destroy as it is a git submodule.

Example : 
```bash
# ./.utils.custom/project/install.sh will add instructions to ./.utils/project/install.sh
```

The following dotfiles that are eligible for instructions adding :
- docker/buildProjectConfig.sh : default config => php7.1 / nginx / mysql - the custom instructions will be executed at the end of each method.
    > setEnvVariables() : replace the default .env laradock variables for your project
    > customizeDockerFiles() : customize the laradock dockerfiles
    > customizeDockerComposeFile() : customize the laradock docker-compose.yml file
    > setNginxConfig() : set the laradock nginx project config
- project/install.sh : the custom instructions will be executed at the end of the script.
