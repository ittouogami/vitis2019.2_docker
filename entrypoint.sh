#!/bin/bash
USER=${USER:-root}
USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
#echo "Starting with UID : $USER_ID, GID: $GROUP_ID,USER: $USER"

UART_GROUP_ID=${UART_GROUP_ID:-20}
if ! grep -q "x:${UART_GROUP_ID}:" /etc/group; then
  groupadd -g "$UART_GROUP_ID" uart
fi
UART_GROUP=$(grep -Po "^\\w+(?=:x:${UART_GROUP_ID}:)" /etc/group)

if [[ -n "$USER_ID" ]]; then
  usermod -l hara builduser
  groupmod -n hara builduser
  export HOME=/home/$USER
  usermod -d $HOME $USER
  usermod -aG sudo $USER
  usermod -aG $UART_GROUP $USER
  echo ${USER}:${USER} |chpasswd
  chown $USER $(tty)
  exec /usr/sbin/gosu "$USER" "$@"
else
  exec "$@"
fi

