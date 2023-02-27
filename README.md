# SoF1 Linux
TLDR: This uses docker as an installer, but doesn't expect you to run the game inside a container. Hardware accelerated gaming is better outside of a container.  

**An attempt to revive native linux versions of Soldier Of Fortune 1 first person shooter game.**
## What sets the linux version apart from the windows one?
The windows community runs **1.07f**. Since the multiplayer is one of the most-loved aspects of the game, its sad that the **1.06a** linux version cannot play alongside windows players, who are using almost identical network protocols.  This project attempts to allow the different versions to play alongside each other.
## Docker, why?
Initially, I thought that the incompatibility of this old game with modern linux distributions would be too great to even attempt *NOT* using docker or a chroot of some sort.

However, after countless hours of testing and debugging. It seems the incompatibility isn't so great.  After completing the docker version, I realised that the docker solution presents a limitation that outweighs the initial one.  

### The Limitation of Docker for 3d accelerated Gaming.
3d hardware acceleration being a pain to setup for the wide variety of graphic drivers in use by linux users.  Especially so if the version of the distro in the Dockerfile is many iterations behind the host distro.  There would be a version mis-match and all sorts of issues might prop up.

If the distro is the same version as the host it still requires manual intervention by the user and thus to have knowledge of setting up the system.  Whereas if they did not use docker, they already have a functioning hardware accelerated system and its just a matter of installing the program.

### Docker useful when running server
It could be useful to run a sof server inside a docker container though.  Because its very encapsulated and easily restartable etc.

### Using docker as an installer only.
For the client-side game, I will use docker only as an installer.  If the user wants to run the game inside a docker container, so be it.  Its down to them to fix the hardware accelerated alignment problem.





## For audio to work
`sudo apt install osspd`  
This is required for audio to function.
## Choose to build image or download image pre-built
### Prebuilt
TODO:not sure how to do this yet!  
Verified.!
### Build yourself 
Depending if your pi is member of docker group, you will have to use sudo  
`cd soflinux`  
`sudo bash build`  
## Run
**Do not use sudo on the run script even if you are not docker grouped, the script will handle this for you.**  
NOTE: Any extra commands passed in to ./run will be forwarded to the game executable.  
eg. `./run +set name MVP`  
will launch with player name set to MVP.  
### Multiplayer
`cd soflinux`  
`chmod +x run-multiplayer`  
`./run-multiplayer +connect ip_of_server:port`
#### Multiplayer ip server list
[https://sof1.megalag.org/server/sof](https://sof1.megalag.org/server/sof)
## Folders
`@outsideContainer $HOME/.loki/sof` - user dir where game savefiles and in-game downloaded content are stored. This folder is mounted into the docker container when it is ran.  
`@outsideContainer $HOME/.loki/sof-base` - .pak files are loaded from this directory, also monted into the container at run-time. Its also the folder that an **autoexec.cfg** is searched.  
`@insideContainer /home/mullins/sof/static_files` - game pak files, pak0,pak1,pak2 etc.  

## TroubleShooting
If you use proprietry gpu drivers, you might want to edit the Dockerfile to install the priorietry glx drivers.  If you're gpu doesn't function with the mesa drivers in the default repo of `bionic`, you may want to try upgrading the drivers there, using a fresh mesa ppa (also by appending to the Dockerfile).
