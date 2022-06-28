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
### Challenge 4: Examining network traffic

Start network testing from h1. We know IP addresses on the hosts are configured, so test network connectivity from h1 to h2, h3 and h4 using the ping command. Note the results.
```
bash-5.1# ping 192.168.1.200
bash-5.1# ping 192.168.2.15
bash-5.1# ping 192.168.2.215
```
Pings were successful from h1 to h2, but failed from h1 to h3 and h4. Although we know r1 is not configured, try to ping 192.168.1.1 and note the response. Are the responses different from the failed pings to h3/h4 and r1?

---
## Configuring Vyos
### Challenge 5: Configure Default Gateway Interfaces
Interface eth1 on r1 and r2 are used as the default gateways to networks 192.168.1.0/24 and 192.168.2.0/24. However, those interfaces are not configured. This challenge introduces you interface configuration on Vyos routers. Routers r1 and r2 are Linux containers. Vyos runs inside those containers. The containers do not have an SSH server running, so use **docker exec** to obtain a shell in r1. The user vyos must be used to configure the routers. The following command switches to user vyos at login.
```
$ sudo docker exec -it clab-lab1-r1 su vyos
vyos@vyos:~$ 
```
Examine the running configuration.
```
vyos@vyos:/$ show conf
interfaces {
    loopback lo {
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    host-name r1
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
        }
    }
    ntp {
        server time1.vyos.net {
        }
        server time2.vyos.net {
        }
        server time3.vyos.net {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
}
```
Next, examine interfacs.
```
vyos@vyos:/$ show interfaces 
Codes: S - State, L - Link, u - Up, D - Down, A - Admin Down
Interface        IP Address                        S/L  Description
---------        ----------                        ---  -----------
eth0             172.20.0.7/24                     u/u  
                 2001:172:20::7/80                      
eth1             -                                 u/u  
eth2             -                                 u/u  
lo               127.0.0.1/8                       u/u  
                 ::1/128                                
```
Note that currently interfaces eth1 and eth2 are not configured. So, configure eth1 (the default gateway). To configure an interface, go to configure mode (**configure**). Note, Vyos supports truncated commands (*conf* in place of *configure*).

Use the **set interface eth <interface> address <IP address/netmask>** command to configure the interface. For example, **set interface ethernet eth1 address 192.168.1.1/24**. Commit changes with the **commit** command and save running configurations to the start-up configuration with the **save** command.
```
vyos@vyos:/$ conf
vyos@vyos# set interface ethernet eth1 address 192.168.1.1/24
[edit]
vyos@vyos# commit
[ interfaces ethernet eth1 ]
sudo: unable to resolve host vyos: Temporary failure in name resolution
Warning: could not set speed/duplex settings: operation not permitted!
[edit]
vyos@vyos# save
sudo: unable to resolve host vyos: Temporary failure in name resolution
Saving configuration to '/config/config.boot'...
Done
[edit]
vyos@vyos# 
```
Use the **exit** command to return to operational mode and run the **show configuration** command again.
```
vyos@vyos# exit
vyos@vyos:/$ show conf
interfaces {
    ethernet eth1 {
        address 192.168.1.1/24
    }
    loopback lo {
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    host-name r1
    login {
        user vyos {
            authentication {
                encrypted-password ****************
                plaintext-password ****************
            }
        }
    }
    ntp {
        server time1.vyos.net {
        }
        server time2.vyos.net {
        }
        server time3.vyos.net {
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
}
```
Note interface eth1 has the IP address and subnet mask configured. Test network operation again.

---
### Challenge 6: Test the Default Gateway

Now that interface eth1 on r1 is configured, hosts h1 and h2 should be able to communicate with that interface. Traffic to any destination outside of the local network for h1 and h2 (192.168.1.0/24) should be forwarded to the default gateway. Ping will demonstrate the default gateway is up and traceroute will demonstrate that traffic to external networks is forwarded from the host to the default gateway. These tests are demonstrated below. Pings to the default gateway are successful and traceroute to an external destination uses 192.168.1.1 as the first hop. Not surprisingly, subsequent hops do not respond. 

```
bash-5.1# ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.426 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.182 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.170 ms
^C
--- 192.168.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2025ms
rtt min/avg/max/mdev = 0.170/0.259/0.426/0.117 ms
bash-5.1# traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 46 byte packets
 1  192.168.1.1 (192.168.1.1)  0.011 ms  0.007 ms  0.007 ms
 2  *  *  *
 3  *  *  *
```
Pings from r1 to an external host (i.e., 8.8.8.8) are successful, but pings from h1 to an external host (i.e., 8.8.8.8) fail. This failure is a little complex to understand at this point. The **show ip route** command on r1 shows a default route to the management network. Router r1 is forwarding packets from h1 to 8.8.8.8 out interface eth0, but the host's external network is not in *promiscuous mode*, and therefore does not forward the packets. We could solve this problem by configuring SNAT on eth0, but for now we will leave this alone and continue configuring r1 and r2.

```
vyos@vyos:/$ show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 172.20.0.1, eth0, 00:14:45
C>* 172.20.0.0/24 is directly connected, eth0, 00:14:45
C>* 192.168.1.0/24 is directly connected, eth1, 00:05:26
```

---
### Challenge 7: Configure and Test r1 eth2

The link between r1 and r2 terminates on interface eth2 of each router. The subnet 192.168.3.0/30 is reserved for the link between r1 and r2. The subnet has two assignable IP addresses, 192.168.3.1 and 192.168.3.2. Configure r1 eth2 with 192.168.3.1, as shown in the network diagram.

Configuring r1 eth2:
```
vyos@vyos:~$ conf
[edit]
vyos@vyos# set int eth eth2 addr 192.168.3.1/30
[edit]
vyos@vyos# commit
[ interfaces ethernet eth2 ]
sudo: unable to resolve host vyos: Temporary failure in name resolution
Warning: could not set speed/duplex settings: operation not permitted!

[edit]
vyos@vyos# save
sudo: unable to resolve host vyos: Temporary failure in name resolution
Saving configuration to '/config/config.boot'...
Done
[edit]
```
Testing r1 eth2 from h1:
```
bash-5.1# ping 192.168.3.1
PING 192.168.3.1 (192.168.3.1) 56(84) bytes of data.
64 bytes from 192.168.3.1: icmp_seq=1 ttl=64 time=0.432 ms
64 bytes from 192.168.3.1: icmp_seq=2 ttl=64 time=0.252 ms
^C
--- 192.168.3.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1021ms
rtt min/avg/max/mdev = 0.252/0.342/0.432/0.090 ms
```

Next, run traceroute to r1 eth2, but first a word about traceroute operation. Traceroute uses echo requests with TTL values initially set at 1 and incrementing by 1 to identify hops. Each hop (router) that receives a packet decrements the TTL by 1 and forwards the packet to the destination. When TTL decrements to zero (0), the hop that decremented TTL to zero drops the packet and returns an ICMP type 11-Time Exceeded error to the source of the dropped packet. The node that receives the Time Exceeded error examines records the sender of the error as a hop, increments the TTL by 1 and sends the next echo request. The process continues until the echo request reaches the target host in the traceroute.

**Each hop will respond only one time.** This is an important nuance to understand. Normally the interface returning the ICMP type 11-Time Exceeded error will be the first interface encountered on the router. For example, the first interface receiving traceroute requests from h1 will be the default gateway, r1 eth1. However, if the destination IP address is assigned to an interface on the hop, that interface will respond. Consider a traceroute from h1 to 192.168.3.1. IP address 192.168.3.1 is assigned to r1 eth2, so the interface that will respond as the first hop to a traceroute to 192.168.3.1 will be r2 eth2. Let's demonstrate that behavior.
```
bash-5.1# traceroute 192.168.3.1
traceroute to 192.168.3.1 (192.168.3.1), 30 hops max, 46 byte packets
 1  192.168.3.1 (192.168.3.1)  0.010 ms  0.009 ms  0.006 ms
```

---
### Challenge 8: Configure and Test r2

Using the network diagram and experience gained by configuring r1, configure interfaces eth1 and eth2 on r2. Demonstrate the ability to ping from h3/h4 to r2 eth1 and eth2. **Capture a screenshot showing successful pings from h3 to r2 eth1 and eth2.**

---
### Challenge 9: Configuring Static Routes on r2
Interfaces on routers r1 and r2 are configured and tests demonstrate that hosts h1 through h4 can communicate with both interfaces eth1 and eth2 on their default gateways. We can also demonstrate that the link between r1 and r2 is operational by pinging from r1 to 192.168.3.2 (r2) and from r2 to 192.168.3.1 (r1), as shown here.
```
r2# ping 192.168.3.1
PING 192.168.3.1 (192.168.3.1): 56 data bytes
64 bytes from 192.168.3.1: seq=0 ttl=64 time=0.936 ms
64 bytes from 192.168.3.1: seq=1 ttl=64 time=0.104 ms
```

However, a ping from any host across the link between r1 and r2 fails. For example, h1 can ping to 192.168.3.1 succeeds but a ping to 192.168.3.2 fails. This result is observed even when we know the link between r1 and r2 is up and functional. The failure is a *routing problem*. Routers r1 and r2 do not know routes to any network other than local networks. First, let's demonstrate the routing problem.

**Successful pings from h1 to r1 and a failed ping from h1 to r2.**
```
bash-5.1# hostname
h1
bash-5.1# ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.270 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.192 ms
^C
--- 192.168.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1023ms
rtt min/avg/max/mdev = 0.192/0.231/0.270/0.039 ms
bash-5.1# ping 192.168.3.1
PING 192.168.3.1 (192.168.3.1) 56(84) bytes of data.
64 bytes from 192.168.3.1: icmp_seq=1 ttl=64 time=0.162 ms
64 bytes from 192.168.3.1: icmp_seq=2 ttl=64 time=0.078 ms
^C
--- 192.168.3.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1018ms
rtt min/avg/max/mdev = 0.078/0.120/0.162/0.042 ms
bash-5.1# ping 192.168.3.2
PING 192.168.3.2 (192.168.3.2) 56(84) bytes of data.
^C
--- 192.168.3.2 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3073ms

```
**Successful pings from r1 to r2, demonstrating the link is UP**
```
r1# ping 192.168.3.1
PING 192.168.3.1 (192.168.3.1): 56 data bytes
64 bytes from 192.168.3.1: seq=0 ttl=64 time=0.110 ms
^C
--- 192.168.3.1 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.110/0.110/0.110 ms

r1# ping 192.168.3.2     
PING 192.168.3.2 (192.168.3.2): 56 data bytes
64 bytes from 192.168.3.2: seq=0 ttl=64 time=0.192 ms
64 bytes from 192.168.3.2: seq=1 ttl=64 time=0.110 ms
64 bytes from 192.168.3.2: seq=2 ttl=64 time=0.114 ms
^C
--- 192.168.3.2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.110/0.138/0.192 ms

```
Next, examine routes on r1 using the command **show ip route**.
```
vyos@vyos:~$ show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 172.20.0.1, eth0, 01w4d02h
C>* 172.20.0.0/24 is directly connected, eth0, 01w4d02h
C>* 192.168.1.0/24 is directly connected, eth1, 00:00:18
C>* 192.168.3.0/30 is directly connected, eth2, 00:02:35
```
We see three directly connected networks. These are the local networks 192.168.1.0/24 and 192.168.3.0/30 that we configured. Network 172.20.0.0/24 is Docker's management network, but is also the default route to the Internet. However, note that there is no route to 192.168.2.0/24. As a result, any packet received that is destined to 192.168.2.0/24 will be forwarded out the default route (if configured) or dropped. 

Recall though, the problem is that pings from h1 to 192.168.3.2 fail. The problem is on r2, not r1. Just like r1 does not have a route to 192.168.2.0/24, r2 does not have a route to 192.168.1.0/24. The packet will be forwarded from r1 to r2, but when r2 attempts to respond, it finds there is no route to 192.168.1.0/24, and would therefore send the response out its default route. We can prove this theory by configuring a **static route** to 192.168.1.0/24 on r2. Let's try.

Syntax to add a static route: **ip route <destination network> <next-hop>**
Syntax to add static route to 192.168.1.0/24 with next-hop 192.168.3.1: **ip route 192.168.1.0/24 192.168.3.1**

**On r2:**
```
vyos@vyos:~$ conf
[edit]
vyos@vyos# set protocol static route 192.168.1.0/24 next-hop 192.168.3.1
[edit]
vyos@vyos# commit
[edit]
vyos@vyos# save
Saving configuration to '/config/config.boot'...
Done

vyos@vyos# exit
exit
vyos@vyos:~$ show ip route
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 172.20.0.1, eth0, 01w4d02h
C>* 172.20.0.0/24 is directly connected, eth0, 01w4d02h
S>* 192.168.1.0/24 [1/0] via 192.168.3.1, eth2, weight 1, 00:00:43
C>* 192.168.2.0/24 is directly connected, eth1, 00:03:06
C>* 192.168.3.0/30 is directly connected, eth2, 00:05:23
```

**Test communication to 192.168.3.2 from h1**
```
bash-5.1# hostname
h1
bash-5.1# ping 192.168.3.2
PING 192.168.3.2 (192.168.3.2) 56(84) bytes of data.
64 bytes from 192.168.3.2: icmp_seq=1 ttl=63 time=0.173 ms
64 bytes from 192.168.3.2: icmp_seq=2 ttl=63 time=0.106 ms
^C
--- 192.168.3.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1012ms
rtt min/avg/max/mdev = 0.106/0.139/0.173/0.033 ms
```

---
### Challenge 10: Configuring Static Routes on r1
A static route to 192.168.1.0/24 has been added to r2. Now, add a static route to 192.168.2.0/24 on r1. **Capture a screen shot demonstrating successful pings from h1 to h3.**

---

## Stretch
### Challenge 11: Examine Configuration
Examine the running configuration with the **show configuration** command.
```
vyos@vyos:~$ show configuration
interfaces {
    ethernet eth1 {
        address 192.168.2.1/24
    }
    ethernet eth2 {
        address 192.168.3.2/30
    }
    loopback lo {
    }
}
protocols {
    static {
        route 192.168.1.0/24 {
            next-hop 192.168.3.1 {
            }
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
:
```
The running configuration is created by loading a configuration at boot and applying committed changes. The boot configuration is stored in file **config.boot**. Use the find command to locate config.boot. Note, the string 2>/dev/null is appended to the find command **find / -name config.boot** to *suppress permission* denied errors. 
```
vyos@vyos:~$ find / -name config.boot 2>/dev/null
/opt/vyatta/etc/config/archive/config.boot
/opt/vyatta/etc/config/config.boot
```
The file we are interested in is /opt/vyatta/etc/config/config.boot. We can read /opt/vyatta/etc/config/config.boot with the **cat** command. See the truncated contents of config.boot.
```
vyos@vyos:~$ cat /opt/vyatta/etc/config/config.boot
interfaces {
    ethernet eth1 {
        address 192.168.2.1/24
    }
    ethernet eth2 {
        address 192.168.3.2/30
    }
    loopback lo {
    }
}
protocols {
    static {
        route 192.168.1.0/24 {
            next-hop 192.168.3.1 {
            }
        }
    }
}
```
**Copy and paste the running-configuarations for r1 and r2 and save them to a file.**
