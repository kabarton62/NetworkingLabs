# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Network Topology and Reading deploy.sh
### Challenge 1: Network Topology

This lab deploys a simple network with two routers (r1 and r2), two Ethernet switches (clab-br1 and clab-br2) and three Linux hosts (h101, h102 and h201). Hosts h101 and h102 are in the same network (192.168.1.0/24), and r1 eth1 is the **default gateway** for that network. Host h201 is in 172.16.1.0/24 and r2 eth1 is the default gateway for h201. Routers r1 and r2 are connected via an Ethernet link. The link connects to interface eth2 on each router.

IP addresses and default gateways are configured on h101, h102 and h201 when the network is deployed. Routers r1 and r2 are also configured at the time the network is deployed. However, r1 and r2 have configuration errors when the network is initially deployed.

<p align="center">
<img src="../images/routing_troubleshooting.png" width="300" height="500">
</p>
<p align="center">
<sub><i>Figure 1. Network Topology</i></sub>
</p>

<p></p>
<p></p>

--- 
## Operating the Lab Network
### Challenge 2: Deploy the Lab Network
Launch the topology by running the script deploy.sh and **capture a screenshot of the results**.
```
  $ bash deploy.sh
```
--- 
## Testing Network Function
### Challenge 3: Test network operation

The host and router nodes in this lab do not have an SSH server running at start-up. *Docker exec* will be used to gain shell access to the nodes in this lab.
```
docker exec syntax:
 sudo docker exec -it <CONTAINER-NAME or CONTAINER-ID> bash

Example (getting shell in host h101):
 $ sudo docker exec -it clab-lab1-h101 bash
```
Get a shell on h1 and run the following commands. **Capture a screenshot of the results**. 

Attempt to ping h201. 
```
bash-5.1# ping 172.16.1.5
```
Note the results. All packets are lost. 

Multiple problems could be the root cause(s) for this network failure.

--- 
### Challenge 4: Test the local network 192.168.1.0/24 and Default Gateway r1/eth1

Pings from h101 to h201 failed. The first step is to determine if the problem is in the local network our outside of the local network. Successfully pinging the Default Gateway would demonstrate:

1. Layer 2 and Layer 1 (L2 & L1) between h101 and r1/eth1 are functional
2. Layer 3 (L3) on r1/eth1 is functional
3. L3 and below (L2 & L1) on h101

---
Pings from h101 to r1/eth1 fail.
```
bash-5.1# hostname
h101
bash-5.1# ping 192.168.1.254
PING 192.168.1.1 (192.168.1.254) 56(84) bytes of data.
From 192.168.1.5 icmp_seq=1 Destination Host Unreachable
From 192.168.1.5 icmp_seq=2 Destination Host Unreachable
From 192.168.1.5 icmp_seq=3 Destination Host Unreachable
^C
--- 192.168.1.1 ping statistics ---
4 packets transmitted, 0 received, +3 errors, 100% packet loss, time 3054ms
```
Let's look at one more thing: pinging from h101 to h102.
```
bash-5.1# hostname
h101
bash-5.1# ping 192.168.1.215
PING 192.168.1.215 (192.168.1.215) 56(84) bytes of data.
64 bytes from 192.168.1.215: icmp_seq=1 ttl=64 time=0.089 ms
64 bytes from 192.168.1.215: icmp_seq=2 ttl=64 time=0.116 ms
64 bytes from 192.168.1.215: icmp_seq=3 ttl=64 time=0.079 ms
^C
--- 192.168.1.215 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2026ms
rtt min/avg/max/mdev = 0.079/0.094/0.116/0.015 ms
```
So, we can ping from h101 to h102, but pings from h101 to r1/eth1 fail. This tells us:
1. h101's IP address is in the same subnet as h102. That is good news.
2. h101's L1 and L2 to the Ethernet switch is working.

At this point, we might suspect a problem with r1/eth1 or the connection between the switch and r1/eth1. So, let's move our attention to r1.

### Challenge 5: Examine r1
First test r1/eth1 by attempting to ping from r1 to h101 and h102.
```
vyos@vyos:/$ ping 192.168.1.5
PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
^C
--- 192.168.1.5 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3055ms

vyos@vyos:/$ ping 192.168.1.215
PING 192.168.1.215 (192.168.1.215) 56(84) bytes of data.
64 bytes from 192.168.1.215: icmp_seq=1 ttl=64 time=0.202 ms
64 bytes from 192.168.1.215: icmp_seq=2 ttl=64 time=0.084 ms
64 bytes from 192.168.1.215: icmp_seq=3 ttl=64 time=0.090 ms
^C
--- 192.168.1.215 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2049ms
rtt min/avg/max/mdev = 0.084/0.125/0.202/0.054 ms
```
The results show that r1 can ping h102 but not h101. This is an interesting result that seems to make no sense, but we can draw at least one important conlusion. L2 and L1 are functional between r1 and 192.168.1.0/24. Therefore, the problem is a L3 problem. Let's dig a little deeper into r1 configuration.
```
vyos@vyos:/$ show interfaces 
Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down
Interface        IP Address                        S/L  Description
---------        ----------                        ---  -----------
eth0             172.20.0.4/24                     u/u  
                 2001:172:20::4/80                      
eth1             192.168.1.254/25                  u/u  
eth2             172.20.1.5/30                     u/u  
lo               127.0.0.1/8                       u/u  
                 ::1/128                                
```
Here, we see the problem. Interface eth1 is mis-configured. The interface is configured with the correct IP address (192.168.1.254) but the wrong subnet mask (/25 vs /24). We can look at the known routes for h101 and h102 using the **show ip route IP Address** command.
  
```
vyos@vyos:/$ show ip route 192.168.1.5
Routing entry for 0.0.0.0/0
  Known via "kernel", distance 0, metric 0, best
  Last update 00:48:49 ago
  * 172.20.0.1, via eth0

vyos@vyos:/$ show ip route 192.168.1.215
Routing entry for 192.168.1.128/25
  Known via "connected", distance 0, metric 0, best
  Last update 00:48:57 ago
  * directly connected, eth1  
```
We see the route to h102 is to network 192.168.1.128/25, but the route to h101 is out the default route on the management network. Fix this error by deleting r1/eth1 configuration and adding the correct IP address and subnet mask.
```
del interface eth eth1 address
set interface eth eth1 address 192.168.1.254/24
commit
save
```
Now, test the connection between r1/eth1 and h1.
```
vyos@vyos:/$ ping 192.168.1.5
PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
64 bytes from 192.168.1.5: icmp_seq=1 ttl=64 time=0.190 ms
64 bytes from 192.168.1.5: icmp_seq=2 ttl=64 time=0.085 ms
64 bytes from 192.168.1.5: icmp_seq=3 ttl=64 time=0.087 ms
^C
--- 192.168.1.5 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2030ms
rtt min/avg/max/mdev = 0.085/0.120/0.190/0.049 ms
```
