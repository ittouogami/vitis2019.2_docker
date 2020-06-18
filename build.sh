IPADDRESS=$(ip addr show $( netstat -rn | grep UG | awk -F' ' '{print $8}')\
    | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
    | grep -o [0-9].*)
docker image build \
    --rm \
    --build-arg IP=${IPADDRESS} \
    --build-arg VITIS_VER=2019.2 \
    --build-arg VITIS_MAIN=Xilinx_Vitis_2019.2_1106_2127.tar.gz \
    --no-cache \
    -t vitis${VIVADO_VER} .
