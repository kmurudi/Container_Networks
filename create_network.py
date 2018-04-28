#!/usr/bin/python

import os
import subprocess
import sys

veth_octet=1
br_octet=20
br_num=1

#main function
def vethnw(container_list):
    for i in range(0,len(container_list)):
        os.system("sudo docker run -itd --privileged --name="+container_list[i]+" fw_ubuntu")
    os.system("sudo ip link add veth"+container_list[0]+" type veth peer name veth"+container_list[1])
    #getting pids
    pids=[]
    ips = []
    global veth_octet

    ips.append("172.18."+str(veth_octet)+".10/24")
    ips.append("172.18."+str(veth_octet)+".11/24")
    veth_octet=veth_octet+1
    for i in range(0,2):
        output = subprocess.Popen("sudo docker inspect -f '{{.State.Pid}}' "+container_list[i], stdout=subprocess.PIPE, shell=True)
        (out, err) = output.communicate()
        pids.append(out.strip())

    print pids
    print ips

    for i in range(0,2):
        os.system("sudo ip link set veth"+container_list[i]+" netns "+pids[i] )
        os.system("sudo docker exec -it "+container_list[i]+" ip link set veth"+container_list[i]+" up")
        os.system("sudo docker exec -it "+container_list[i]+" ip addr add "+ips[i]+" dev veth"+container_list[i])


def bridgenw(container_list):
    for i in range(0,len(container_list)):
        os.system("sudo docker run -itd --privileged --name="+container_list[i]+" fw_ubuntu")
    global br_num
    os.system("sudo brctl addbr br"+str(br_num))
    os.system("sudo ip link set br"+str(br_num)+" up")
    for i in range(0,len(container_list)):
        os.system("sudo ip link add veth"+container_list[i]+" type veth peer name br"+str(br_num)+str(i))

    pidsbr=[]
    for i in range(0,len(container_list)):
        output = subprocess.Popen("sudo docker inspect -f '{{.State.Pid}}' "+container_list[i], stdout=subprocess.PIPE, shell=True)
        (out, err) = output.communicate()
        pidsbr.append(out.strip())
    
    ips = []
    global br_octet
    base_ip=10
    for i in range(0,len(container_list)):
        ips.append("192.168."+str(br_octet)+"."+str(base_ip))
        base_ip=base_ip+1

    print pidsbr
    print ips

    for i in range(0,len(container_list)):
        os.system("sudo ip link set veth"+container_list[i]+" netns "+pidsbr[i] )
        os.system("sudo docker exec -it "+container_list[i]+" ip link set veth"+container_list[i]+" up")
        os.system("sudo docker exec -it "+container_list[i]+" ip addr add "+ips[i]+" dev veth"+container_list[i])
        os.system("sudo docker exec -it "+container_list[i]+" ip route add 192.168."+str(br_octet)+".0/24 dev veth"+container_list[i])
        os.system("sudo brctl addif br"+str(br_num)+" br"+str(br_num)+str(i))
        os.system("sudo ip link set br"+str(br_num)+str(i)+" up")

    br_num=br_num+1
    br_octet=br_octet+1
    
def tunnelnw(container_list):
    subnet_input = raw_input("Which containers do you want to use the GRE tunnel for?\n 1. CS1, CS3 \n 2. CS2, CS4\n")
    os.system("./rules_add.sh")
    print "Topology created and gre tunnel created between SC1 and SC2. Any packets between your containers will now take this tunnel path."

def main():
    while True:
        container_list  = []
        str_list = raw_input("Enter the list of containers: \n")
        container_list = str_list.split()

        
        network_type = int(raw_input("Enter type of network between them: \n 1 Veth Pair \n 2 Bridge Network \n 3 GRE Tunnel \n"))
        if network_type == 1:
           vethnw(container_list)

        elif network_type == 2:
           bridgenw(container_list)
        elif network_type == 3:
           tunnelnw(container_list)

        exit=raw_input("Do you want to exit?\n Yes \n No\n")
        if exit == "Yes":
           sys.exit()


if __name__ == "__main__":
    main()
