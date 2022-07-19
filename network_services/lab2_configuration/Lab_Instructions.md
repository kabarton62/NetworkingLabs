# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Network Services
### Challenge 1: Network Topology

This labs deploys a simple network with routers, DHCP clients, two DNS servers and a web server. IP addresses are configured on the servers and routers. Those IP addresses are not provided in the network Diagram so users must extract those IP addresses from the nodes. 

Users will configure DHCP service and NAT on eth1 interfaces on R1 and R2. Users must manually request a DHCP lease on hosts H1 and H2 after configuring DHCP service and NAT on routers R1 and R2. 

Users will also configure a DNS zone on DNS1 and configure DNS2 to pull that zone from DNS1 through a zone transfer.

Users will finally configure DNS service on R1 and R2 and direct DNS forwarding to DNS1 and DNS2.

<p align="center">
<img src="../images/netServices-pract.png" width="500" height="450">
</p>
<p align="center">
<sub><i>Figure 1. Network Topology</i></sub>
</p>

<p></p>
<p></p>

--- 
## Operating the Lab Network
### Challenge 2: Deploy the Lab Network
Launch the topology by running the script deploy.sh and manually launch the http service on the web server.
```
  $ bash deploy.sh
  $ sudo docker exec -it clab-lab1-web /httpd.sh

Confirm that you can browse to the web server
  
  $ sudo docker exec -it clab-lab1-web ifconfig eth0
  $ curl http://<web eth0 ip address>
```
--- 
## Challenge 3: Configuring DHCP Service
### Configure a DHCP pool on router LAN interfaces (eth1)

DHCP dnymically configures network services on DHCP clients. A DHCP client requests a *lease* from the DHCP server. The DHCP responds with an IP address and subnet mask, Default Gateway, name servers (DNS servers), lease time and other details. The DHCP client then uses that lease for network communications. Routers R1 and R2 each have a LAN directly connected to eth1. A DHCP pool provides the IP address range and other configuration details the DHCP server will use to issue leases to DHCP clients.

**Configure DHCP pools on R1 and R2 eth1 interfaces**. Use the following configuration deails:

Start IP address (the first IP address in the pool): x.x.x.51
Stop IP address (the last IP address in the pool): x.x.x.150
Lease Expiration of 84600 seconds (24 hours)
Name Server: R1/eth1 address on R1 and R2/eth1 IP address on R2
Gateway: R1/eth1 address on R1 and R2/eth1 IP address on R2

Example, assuming R1 had IP address 10.10.10.1/24:
```
set service dhcp-server shared-network-name LAN authoritative
set service dhcp-server shared-network-name LAN subnet 10.10.10.0/24 default-router 10.10.10.1
set service dhcp-server shared-network-name LAN subnet 10.10.10.0/24 lease 84600
set service dhcp-server shared-network-name LAN subnet 10.10.10.0/24 name-server 10.10.10.1
set service dhcp-server shared-network-name LAN subnet 10.10.10.0/24 range 0 start 10.10.10.51
set service dhcp-server shared-network-name LAN subnet 10.10.10.0/24 range 0 start 10.10.10.150
```

### Manually force a DHCP request from a client

Normally DHCP requests happen automatically when a DHCP client is added to a network, but in this case we will manually force a DHCP request with the **dhclient** command.

Use dhclient to force a DHCP lease resnew.
```
# Request DHCP lease with dhclient
dhclient eth1

#Verify IP addressed assigned
ifconfig eth1
```
**Capture a screenshot of the results of ifconfig on H1 demonstrating that H1 as an IP address assigned to eth1.**

--- 
## Challenge 4, Examine DHCP leases on Vyos
Get a shell on R1. From **operation mode**, examine the DHCP server to verify that H1's lease can be observed.

```
show dhcp server leases

  IP address    Hardware address    State    Lease start          Lease expiration     Remaining    Pool    Hostname
  ------------  ------------------  -------  -------------------  -------------------  -----------  ------  ----------
  10.100.1.51   aa:c1:ab:3e:17:f2   active   2022/07/19 18:00:39  2022/07/20 17:30:39  21:48:58     LAN     h1


show dhcp server statistics

  Pool      Size    Leases    Available  Usage
  ------  ------  --------  -----------  -------
  LAN        100         1           99  1%
```
**Capture a screenshot showing dhcp server statistics and leases on R1.**

## Challenge 5, DHCP server configuration on R2
Configure DHCP service on R2 and force H2 to pull a DHCP lease. **Capture a screenshot on R2 that demonstrates H2 pulled a DHCP lease from R2.**

