# give xhost permissions to the current user
xhost local:$USER
# run the docker with x11 mounted
docker run -v /tmp/.X11-unix:/tmp/.X11-unix --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -e DISPLAY=$DISPLAY --net=host -it polycraft-dev
