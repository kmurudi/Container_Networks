# Container_Networks
Python scripting and Shell scripting to help provide automated network of Docker container.

Base Machine used for running scripts and set up -> Ubuntu 16.04 LTS

So this project is about giving the user few options to give input as a list of containers and the type of network they want the containers to be connected in.

# Steps for using it are as follows ->

## 1) Install docker.io on your Ubuntu machine - 
```
$ sudo apt-get install docker.io
```

## 2) For creating Docker networks I have used a pre-defined Dockerfile that would install latest Ubuntu base image and needed utilities. It is located at - [Dockerfile](https://github.com/kmurudi/Container_Networks/blob/master/Dockerfile).

Create a Docker image - 
```
$ sudo docker build -t fw_ubuntu .
```
## 3) Run the script [create_network.py](https://github.com/kmurudi/Container_Networks/blob/master/create_network.py) which is an interactive Python script. 
```
$ python create_networks.py

```
## This will give the user three options for creating networks ->
**i. Veth pair - This will take in list of containers (limited to two now since one would want a single veth pair between 2 containers) and then create a veth pair, attach them to the two Docker containers - assign IPs within a same subnet (which is incremented by octet number each time so that duplicate IPs are not assigned).**

**ii. Bridge network - This will take in list of containers, spawn Docker containers, add a bridge using 'brctl' utility and connect the containers to it. Assigns IPs in same subnet to all these containers and adds default routes so that all can ping each other.**

**_Demo run of my script for veth pair and bridge network -_**

![demo](https://github.com/kmurudi/Container_Networks/blob/master/part2_br_veth_demo.PNG)

**iii. Tunnel Network - This will create a GRE tunnel. This was a little tough to think of because the underlay would have to be pre-defined and if the user would need to give so many details, it would not serve the great purpose of automation. So, I have automated the creation of the following topology as show below ->**


![Topology of the Automated network for GRE tunneling option](https://github.com/kmurudi/Container_Networks/blob/master/topology.jpg)

**The user can connect CS1, CS2, CS3, CS4 - customer containers to the GRE tunnel network - which is built between SC1 and SC2. If the need is to only create a tunnel between two containers - it is an easy task just have to add rules on both ends, however it is difficult to understand if we do not know the underlay network.**

**_Thanks I hope you liked this demo! :) Please give it a star if you liked it!_**



