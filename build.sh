IPADDRESS=$(ip addr show wlp3s0 | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o [0-9].*)
docker image build --rm --build-arg IP=$IPADDRESS --no-cache -t vitis2019.2 .
