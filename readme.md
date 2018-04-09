# Laravel utils dotfiles

## Installation
- install the dotfiles in your project with the following command : `git submodule add https://github.com/Okipa/laravel-utils-dotfiles.git .utils`.
- Make sure you add the following lines in the `scripts` part of your `composer.json` file in order to make sure you always have an updated version of this git submodule :
```
"post-install-cmd": [
    ...
    "git submodule sync --recursive && git submodule update --init --recursive --remote --force",
    ...
],
"post-update-cmd": [
    ...
    "git submodule sync --recursive && git submodule update --init --recursive --remote --force",
    ...
]
```
- copy the following command from the root path of your project  : `cp -R .utils/.utils.custom .utils.custom`

### .utils/database/
- drop.sh : drop.
- generatePgsqlDump.sh : generate a pgsql dump.
    > | Argument | Required | Description |
    > |---|---|---|
    > | [destinationPath] | No | Specify a destination path for the pgsql dump |

### .utils/git/submodules/
- update.sh : update all the project git submodules (with the `--init --recursive --remote --force` options by default - you can specify additional options after the script call).

### .utils/helpers/
- checkFileExists.sh : check that the file path given in parameter exists.
    > | Argument | Required | Description |
    > |---|---|---|
    > | [filePath] | Yes | Specify the file path that will be verified |
- checkVariableIsDefined.sh : check that the environment variable given in parameter is defined.
    > | Argument | Required | Description |
    > |---|---|---|
    > | [variable] | Yes | Specify the variable that will be checked |
- exportEnvFileVariables.sh : export the laravel environment variables for a bash use.
    > **Notice :** Only one argument is taken care of, use only one of the possible arguments shown bellow.
    > | Argument | Required | Description |
    > |---|---|---|
    > | [envFilePath] | No | Specify a env file path - by default, the current laravel project env file is used |
    > | -- | No | Force the script to use the default laravel .env file based at the root of the project |
- loadScriptingColors.sh : load the bash scripting colors.
- requiresEnvironment.sh : check the current environment is the one specified during the script execution.
    > | Argument | Required | Description |
    > |---|---|---|
    > | [environmentName] | Yes | Specify the environment name we should get |
- requiresSudoRights.sh : check that a user with sudo rights is used on the script execution.

### .utils/project/
- install.sh : automatically execute all the project installation tasks.

### .utils/server/
- configCheck.sh : check that the server has the required dependencies.
- dumpProdToPreprod : execute a dump from the production toward the preprod (can only be used for the standard preprod/prod projects configurations).
- localesInstall.sh : install the project needed locales.

### .utils/laradock/
- stop.sh : stop the project laradock docker containers.
- up.sh : start the project laradock docker containers (you can add docker options after the script call).
- workspace.sh : shortcut to get a ssh access to the laradock workspace with the `laradock` user.
    > | Option | Required | Description |
    > |---|---|---|
    > | --root | No | Access to the docker laradock workspace with the `root` user |

### .utils/supervisor/
- install.sh : configure and launch the project supervisor runners.
- restart.sh : restart the project supervisor runners.

## Adding instructions to dotfiles
Several dotfiles have to execute custom instructions related to your project needs.
These instructions will have to be specified in the `.utils.custom` directory dotfiles.
This way, your custom instructions will be synchronized with your project git repository where the content of `.utils/` can be fully destroy as it is a git submodule.

The following dotfiles that are eligible for custom instructions :

| Dotfile | Custom dotfile | Actions to set |
|---|---|---|
| .utils/docker/up.sh | .utils.custom/docker/up.sh | Specify which container to start |
| .utils/project/install.sh | .utils.custom/project/install.sh | Add custom instructions at the end of the script |
| .utils/server/dumpProdToPreprod.sh | .utils.custom/server/dumpProdToPreprod/additionalInstructions.sh | Set additional instructions to the script |
| .utils/server/dumpProdToPreprod.sh | .utils.custom/server/dumpProdToPreprod/setVariables.sh | Set required variables need by the script |
| .utils/server/configCheck.sh | .utils.custom/server/configCheck.sh | Set the packages installations to check |
| .utils/server/localesInstall.sh | .utils.custom/server/localesInstall.sh | Install the needed project locales |
