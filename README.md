# SoF1 Linux
## Install
`cd soflinux`
`chmod +x build`
`./build`

## Run
`cd soflinux`
`chmod +x run`
`./run`

## Folders
`@outsideContainer $HOME/.loki/sof` - dir where game savefiles and in-game downloaded content are stored. This folder is mounted into the docker container when it is ran.
`@outsideContainer soflinux/base` - .pak files are loaded from this directory, also monted into the container at run-time. Its also the folder that an **autoexec.cfg** is searched.
`@insideContainer /home/mullins/sof/static_files` - game pak files, pak0,pak1,pak2 etc.

