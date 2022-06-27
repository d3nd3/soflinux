# SoF1 Linux
## Choose to build image or download image pre-built
### Prebuilt
TODO:not sure how to do this yet!
### Build yourself 
as *regular* user, do:  
`cd soflinux`  
`bash build`  
## Run
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


