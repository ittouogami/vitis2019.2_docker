docker run -it --rm \
    --net host \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    -e USER=$USER \
    -e UART_GROUP_ID=20 \
    -e DISPLAY=$DISPLAY \
    -e VIVADO_VER=2019.2 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:$HOME/.Xauthority \
    -v $HOME/docker/userhome:$HOME \
    --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /sys:/sys:ro \
    -w $HOME \
    vitis2019.2
