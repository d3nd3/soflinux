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


## Usage
There is a file named **installer.sh**.  It will use docker to get all of the files into a container, then copy them over to your local system.
### Build Options
`--build-arg RUN_DOCKER_CLIENT=1` - if you intend to run the client through docker container.  
`--build-arg MANUAL_CE=1` - if you want to supply the Community Edition installer from sof1.org.  

### Host requirements
`sudo apt install osspd`  
SoF uses /dev/dsp (oss) as its sound support.  This is very old and only supported if we use a wrapper program `osspd`.  It installs as a service.  But not necessary as `padsp <yourProg>` is sufficient.

## Credits
Me..
