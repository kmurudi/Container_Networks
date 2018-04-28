sudo docker run -itd --privileged  --name=SC1  fw_ubuntu
sudo docker run -itd --privileged  --name=SC2  fw_ubuntu
sudo docker run -itd --privileged  --name=LC1  fw_ubuntu
sudo docker run -itd --privileged  --name=LC2  fw_ubuntu
sudo docker run -itd --privileged  --name=CS1  fw_ubuntu
sudo docker run -itd --privileged  --name=CS2  fw_ubuntu
sudo docker run -itd --privileged  --name=CS3  fw_ubuntu
sudo docker run -itd --privileged  --name=CS4  fw_ubuntu
sudo ip link add sc11 type veth peer name lc11
sudo ip link add sc12 type veth peer name lc22
sudo ip link add sc22 type veth peer name lc12
sudo ip link add sc21 type veth peer name lc21
sudo ip link add lc13 type veth peer name br11
sudo ip link add lc23 type veth peer name br21
sudo ip link add br12 type veth peer name cs1
sudo ip link add br13 type veth peer name cs2
sudo ip link add br22 type veth peer name cs3
sudo ip link add br23 type veth peer name cs4
sudo brctl addbr br1
sudo brctl addbr br2
sudo brctl addif br1 br11
sudo brctl addif br1 br12
sudo brctl addif br1 br13
sudo brctl addif br2 br21
sudo brctl addif br2 br22
sudo brctl addif br2 br23
pid_sc1="$(sudo docker inspect -f '{{.State.Pid}}' "SC1")"
sudo ip link set sc11 netns $pid_sc1
sudo ip link set sc12 netns $pid_sc1
pid_sc2="$(sudo docker inspect -f '{{.State.Pid}}' "SC2")"
sudo ip link set sc21 netns $pid_sc2
sudo ip link set sc22 netns $pid_sc2
pid_lc1="$(sudo docker inspect -f '{{.State.Pid}}' "LC1")"
sudo ip link set lc11 netns $pid_lc1
sudo ip link set lc12 netns $pid_lc1
sudo ip link set lc13 netns $pid_lc1
pid_lc2="$(sudo docker inspect -f '{{.State.Pid}}' "LC2")"
sudo ip link set lc21 netns $pid_lc1
sudo ip link set lc22 netns $pid_lc1
sudo ip link set lc23 netns $pid_lc1
pid_cs1="$(sudo docker inspect -f '{{.State.Pid}}' "CS1")"
sudo ip link set cs1 netns $pid_cs1
pid_cs2="$(sudo docker inspect -f '{{.State.Pid}}' "CS2")"
sudo ip link set lc11 netns $pid_cs2
pid_cs3="$(sudo docker inspect -f '{{.State.Pid}}' "CS3")"
sudo ip link set lc11 netns $pid_cs3
pid_cs4="$(sudo docker inspect -f '{{.State.Pid}}' "CS4")"
sudo ip link set lc11 netns $pid_cs4
sudo docker exec SC1 ip link set sc11 up
sudo docker exec SC1 ip link set sc12 up
sudo docker exec SC1 ip addr add 192.168.5.2/24 dev sc11
sudo docker exec SC1 ip addr add 192.168.7.2/24 dev sc12
sudo docker exec SC2 ip link set sc21 up
sudo docker exec SC2 ip link set sc22 up
sudo docker exec SC2 ip addr add 192.168.8.2/24 dev sc21
sudo docker exec SC2 ip addr add 192.168.6.2/24 dev sc22
sudo docker exec LC1 ip link set lc11 up
sudo docker exec LC1 ip link set lc12 up
sudo docker exec LC1 ip link set lc13 up
sudo docker exec LC1 ip addr add 192.168.5.1/24 dev lc11
sudo docker exec LC1 ip addr add 192.168.6.1/24 dev lc12
sudo docker exec LC1 ip addr add 192.168.10.2/24 dev lc13
sudo docker exec LC2 ip link set lc21 up
sudo docker exec LC2 ip link set lc22 up
sudo docker exec LC2 ip link set lc23 up
sudo docker exec LC2 ip addr add 192.168.8.1/24 dev lc21
sudo docker exec LC2 ip addr add 192.168.7.1/24 dev lc22
sudo docker exec LC2 ip addr add 192.168.20.1/24 dev lc23
sudo docker exec CS1 ip link set cs1 up 
sudo docker exec CS1 ip addr add 192.168.10.3/24 dev cs1
sudo docker exec CS1 ip route del default 
sudo docker exec CS1 ip route add default via 192.168.10.2
sudo docker exec CS2 ip link set cs2 up 
sudo docker exec CS2 ip addr add 192.168.10.4/24 dev cs2
sudo docker exec CS2 ip route del default 
sudo docker exec CS2 ip route add default via 192.168.10.2
sudo docker exec CS3 ip link set cs3 up 
sudo docker exec CS3 ip addr add 192.168.20.2/24 dev cs3
sudo docker exec CS3 ip route del default 
sudo docker exec CS3 ip route add default via 192.168.20.1
sudo docker exec CS4 ip link set cs2 up 
sudo docker exec CS4 ip addr add 192.168.20.3/24 dev cs4
sudo docker exec CS4 ip route del default 
sudo docker exec CS4 ip route add default via 192.168.20.1
#tunnel creation in sc1 and sc2
sudo docker exec SC1 ip tunnel add gre_tun  mode gre local 192.168.7.2 remote 192.168.8.2
sudo docker exec SC1 ip link set gre1 up
sudo docker exec SC1 ip route add 192.168.20.0/24 dev gre_tun

sudo docker exec SC2 ip tunnel add gre_tun mode gre local 192.168.8.2 remote 192.168.7.2
sudo docker exec SC2 ip link set gre_tun up
sudo docker exec SC2 ip route add 192.168.10.0/24 dev gre_tun
#extra route rules
sudo docker exec SC1 ip route add 192.168.10.0/24 via 192.168.5.1
sudo docker exec SC2 ip route add 192.168.20.0/24 via 192.168.8.1
sudo docker exec SC1 ip route add 192.168.8.0/24 via 192.168.7.1
sudo docker exec SC2 ip route add 192.168.7.0/24 via 192.168.8.1
sudo docker exec LC2 ip route add 192.168.10.0/24 via 192.168.8.2
sudo docker exec LC1 ip route add 192.168.20.0/24 via 192.168.5.2