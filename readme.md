# Laravel utils dotfiles

[![Source Code](https://img.shields.io/badge/source-okipa/laravel--utils--dotfiles-blue.svg)](https://github.com/Okipa/laravel-utils-dotfiles)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Utils dotfiles for laravel projects.

------------------------------------------------------------------------------------------------------------------------

## Installation
- install the dotfiles in your project with the following command : `git submodule add https://github.com/Okipa/laravel-utils-dotfiles.git .utils`.
- Make sure you add the following lines in the `scripts` part of your `composer.json` file to make sure that you always have an updated version of this git submodule :
```
// ...
"post-install-cmd": [
    "git submodule sync --recursive && git submodule update --init --recursive --remote --force"
],
"post-update-cmd": [
    "git submodule sync --recursive && git submodule update --init --recursive --remote --force"
],
// ...
```
- copy the following command from the root path of your project  : `cp -R .utils/.utils.custom .utils.custom`

------------------------------------------------------------------------------------------------------------------------

## Requirements
- rsync >= v3.*
- readlink (GNU coreutils) >= v8.*
- realpath (GNU coreutils) >= v8.*

### MacOS users
Some unix functions like `readlink` or `realpath` may have a different implementation on Linux and MacOS.  
To get the same behaviour on the two OS and make these dotfiles work correctly, follow those steps :
- Install the [GNU Coreutils](https://en.wikipedia.org/wiki/GNU_Core_Utilities) : `brew install coreutils`
- Then, add this line to your **.bashrc** or **.zshrc** :
```bash
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
``` 

To get the correct rsync version installed, also execute the following steps :
- install the latest rsync version : `brew install rsync`
- add this line to your **.bashrc** or **.zshrc** :
```bash
export PATH="/usr/bin/local:$PATH"
```

------------------------------------------------------------------------------------------------------------------------

## API

### .utils/database/
- `generatePgsqlDump.sh` : generate a pgsql dump.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [destinationPath] | Yes | Specify a destination path for the pgsql dump |
- `generateMysqlDump.sh` : generate a mysql dump.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [destinationPath] | Yes | Specify a destination path for the pgsql dump |

### .utils/dump/
- `importFromServer.sh` : import a production dump locally.
- `prodToPreprod.sh` : execute a dump from the production and import it in the preprod.

### .utils/git/submodules/
- `update.sh` : update all the project git submodules (with the `--init --recursive --remote --force` options by default - you can specify additional options after the script call).

### .utils/helpers/
- `checkFileExists.sh` : check that the file path given in parameter exists.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [filePath] | Yes | Specify the file path that will be verified |
- `checkVariableIsDefined.sh` : check that the environment variable given in parameter is defined.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [variable] | Yes | Specify the variable that will be checked |
- `exportEnvFileVariables.sh` : export the laravel environment variables for a bash use.

    > **Notice :** Only one argument is taken care of, use only one of the possible arguments listed bellow.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [envFilePath] | No | Specify a custom env file path - if not provided, the current laravel project env file is used |
    > | -- | No | Force the script to use the default laravel .env file based at the root of the project |
- `loadScriptingColors.sh` : load the bash scripting colors.
- `requiresEnvironment.sh` : check the current environment is the one specified during the script execution.

    > | Argument | Required | Description |
    > |---|---|---|
    > | [environmentName] | Yes | Specify the environment name the script should run under |
- `requiresSudoRights.sh` : check that a user with sudo rights is used on the script execution.

### .utils/docker/
- `stop.sh` : stop the project docker containers.
- `up.sh` : start the project docker containers (you can add any docker option after the script call).
- `workspace.sh` : shortcut to get a ssh access to the docker workspace with the right user.

    > | Option | Required | Description |
    > |---|---|---|
    > | --root | No | Access to the docker workspace with the `root` user |

### .utils/server/
- `configCheck.sh` : check that the server has the required dependencies.
- `localesInstall.sh` : install the project needed locales.

### .utils/supervisor/
- `laravelEchoServerInstall.sh` : configure and launch the project laravel-echo-server supervisor task.
- `laravelEchoServerRestart.sh` : restart the project laravel-echo-server supervisor task.
- `laravelQueueInstall.sh` : configure and launch the project laravel queue supervisor task.
- `laravelQueueRestart.sh` : restart the project laravel queue supervisor task.

## Adding instructions to dotfiles
Several dotfiles have to execute custom instructions that will be different regarding your project needs.
These instructions will have to be specified in the `.utils.custom/` directory dotfiles.
This way, your custom instructions will be synchronized with your project git repository where the content of `.utils/` can be fully destroyed as it is a git submodule.

The following dotfiles that are eligible for custom instructions :

### .utils/docker/ => .utils.custom/docker/
- `up.sh` : specify which docker containers to start.
- workspace/
    - `setRequiredVariables.sh` : set the variables required for the docker use.
    
### .utils/dump/ => .utils.custom/dump/
- importFromServer/
    - `additionalInstructions.sh` : set additional instructions at the end of the production dump import script.
    - `generateServerSqlDump.sh` : generate the sql production dump on the project server.
    - `setRequiredVariables.sh` : set the variables required for the production dump import script.
- prodToPreprod/
    - `additionalInstructions.sh` : set additional instructions at the end of the production to preprod dump script.
    - `dropDbTables.sh` : drop the preprod database before the import of the production sql dump in the preprod database.
    - `generateProductionSqlDump.sh` : generate the production sql dump that will be imported in the preprod database.
    - `setRequiredVariables.sh` : set the variables required for the production to preprod dump script.

### .utils/server/ => .utils.custom/server/
- `configCheck.sh` : set which server packages installations we should verify.
- `localesInstall.sh` : install the project needed locales.

### .utils/server/ => .utils.custom/supervisor/
- laravelEchoServerInstall/
    - `setRequiredVariables` : set the variables required for the supervisor task install script.
- laravelHorizonInstall/
    - `setRequiredVariables` : set the variables required for the supervisor task install script. 
- laravelQueueInstall/
    - `setRequiredVariables` : set the variables required for the supervisor task install script.
