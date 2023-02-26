DIR_BASEDIR=~/.loki/sof-addons/base
DIR_USER=~/.loki/sof

# User folder creation
if [ ! -d $DIR_USER ] ; then
  echo "Creating user directory at $DIR_USER..."
  #ensure mounted folders are created before-hand
  #so that permission is not unwriteable root.
  mkdir -p $DIR_USER
else
  if [ `stat --format '%U' $DIR_USER` = "root" ]; then
    echo "Your loki user directory is root-owned, this has to be changed"
    sudo chown -R $USER:$USER $DIR_USER
  fi
fi

# $basedir addons folder creation
if [ ! -d $DIR_BASEDIR ] ; then
  echo "Creating base directory at ~/.loki/sof-addons..."
  echo "Use this for extra map .pak files and autoexec.cfg"
  mkdir -p $DIR_BASEDIR
else
  if [ `stat --format '%U' $DIR_BASEDIR` = "root" ]; then
    echo "Your loki base directory is root-owned, this has to be changed"
    sudo chown -R $USER:$USER $DIR_BASEDIR
  fi
fi