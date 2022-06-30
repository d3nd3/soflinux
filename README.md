# SoF1 Linux
## For audio to work
`sudo apt install osspd`  
This is required for audio to function.
## Choose to build image or download image pre-built
### Prebuilt
TODO:not sure how to do this yet!  
Verified.
### Build yourself 
Depending if your pi is member of docker group, you will have to use sudo  
`cd soflinux`  
`sudo bash build`  
## Run
**Do not use sudo on the run script even if you are not docker grouped, the script will handle this for you.  **  
NOTE: Any extra commands passed in to ./run will be forwarded to the game executable.  
eg. `./run +set name MVP`  
will launch with player name set to MVP.  
### Multiplayer
`cd soflinux`  
`chmod +x run-multiplayer`  
`./run-multiplayer +connect ip_of_server:port`
#### Multiplayer ip server list
[https://megalag.org/server/sof](https://megalag.org/server/sof)
## Folders
`@outsideContainer $HOME/.loki/sof` - user dir where game savefiles and in-game downloaded content are stored. This folder is mounted into the docker container when it is ran.  
`@outsideContainer $HOME/.loki/sof-base` - .pak files are loaded from this directory, also monted into the container at run-time. Its also the folder that an **autoexec.cfg** is searched.  
`@insideContainer /home/mullins/sof/static_files` - game pak files, pak0,pak1,pak2 etc.  


