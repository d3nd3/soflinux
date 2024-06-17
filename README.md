# SoF1 Linux
TLDR: This uses docker as an installer, but doesn't expect you to run the game inside a container. Hardware accelerated gaming is better outside of a container.  

**An attempt to revive native linux versions of Soldier Of Fortune 1 first person shooter game.**

## Usage
`cd soflinux`
`./installer.sh`

### Advanced Users Build Options
*pass extra options to the `installer.sh` or the `docker-build.sh` script for extra control.*  
#### `--build-arg RUN_DOCKER_CLIENT=1`
If you intend to run the executables in a containerized state, through docker.  This will ensure mesa and pulseaudio are installed in the container, to help graphic and audio support. ( NOT RECOMMENDED ).

#### `--build-arg MANUAL_CE=1`
If you want to supply the Community Edition installer from sof1.org, instead of let the script download it.  
You have to put the sof_ce_installer.exe into the docker-context folder.  And it has to be named that exactly : `sof_ce_installer.exe`.


#### Running the game within docker
If you do decide you want this option, its worse because its harder to get hardware-acceleration up and running.  However, keep in mind that it still mounts 2 folders from local machine, so you can easily retain files downloaded from within game and add to them externally.  
1. .loki/sof-addons/base [$BASEDIR/base]     - used for extending game pak files, this has higher priority than the internal game directory.
2. .loki/sof [$USER] - used for saving files that are downloaded from other servers, this has higher priority than both.

### Host requirements
#### osspd
`sudo apt install osspd`  
SoF uses /dev/dsp (oss) as its sound support.  This is very old and only supported if we use a wrapper program `osspd`.  It installs as a service, but not necessary as `padsp <yourProg>` is sufficient.  
#### libsdl1.2-compat
`sudo apt install libsdl1.2-compat`  
This will allow you to alt tab.  The launcher scripts LD_PRELOAD the newer version. (But still depend on original, I believe, thats why both are LD_PRELOADED).

## What sets the linux version apart from the windows one?
The windows community runs **1.07f**. Since the multiplayer is one of the most-loved aspects of the game, its sad that the **1.06a** linux version cannot play alongside windows players, who are using almost identical network protocols.  This project attempts to allow the different versions to play alongside each other.
## Docker, why?
Initially, I thought that the incompatibility of this old game with modern linux distributions would be too great to even attempt *NOT* using docker or a chroot of some sort.

However, after countless hours of testing and debugging. It seems the incompatibility isn't so great.  After completing the docker version, I realised that the docker solution presents a limitation that outweighs the initial one.  

### The Limitation of Docker for 3d accelerated Gaming.
3d hardware acceleration being a pain to setup for the wide variety of graphic drivers in use by linux users.  Especially so if the version of the distro in the Dockerfile is many iterations behind the host distro.  There would be a version mis-match and all sorts of issues might prop up.

If the distro is the same version as the host it still requires manual intervention by the user and thus to have knowledge of setting up the system.  Whereas if they did not use docker, they already have a functioning hardware accelerated system and its just a matter of installing the program.

#### Appendum
While there is graphics acceleration, there are no terminals which could connect to the container and allow you to view the game being played.  
So the method that was used by my testing was exporting the XLib instructions of the client app(sof) to point to the WSL2 host xserver.  Which requires indirect opengl rendering.

### Docker useful when running server
It could be useful to run a sof server inside a docker container though.  Because its very encapsulated and easily restartable etc.

### Using docker as an installer only.
For the client-side game, I will use docker only as an installer.  If the user wants to run the game inside a docker container, so be it.  Its down to them to fix the hardware accelerated alignment problem.



### My Sound Is Not Working What Can I Do?
`sudo systemctl restart osspd`
`systemctl status osspd`
Especially under wsl this helps.

## Credits
Me..
