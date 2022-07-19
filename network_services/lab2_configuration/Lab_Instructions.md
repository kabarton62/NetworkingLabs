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
### Configure DHCP service on R1/eth1 and R2/eth2 and obtain leases on H1 and H2

This skill was practiced in the practice lab. Correctly configure DHCP service on R1 and R2 and force the two hosts H1 and H2 to obtain a DHCP lease. 

**Capture a screenshot(s) showing dhcp server statistics and leases on R1 and R2.**

## Challenge 4, Source NAT configuration
Configure Source NAT (SNAT) on R1. NAT traffic from R1/eth1 to R1/eth2. SNAT is the most common form of NAT. SNAT enables multiple internal or private hosts to access the Internet by sharing a single public IP address of a (S)NAT router. What we commonly refer to as NAT is actually SNAT and uses address translation (NAT), port translation (PAT) and address masquerading. The following commands assume the internal range is 192.168.1.0/24 and the external (public) IP is 150.10.1.1 on eth0, and show SNAT configuration on Vyos under those conditions.

```
set nat source rule 10 outbound-interface eth0
set nat source rule 10 source address 192.168.1.0/24
set nat source rule 10 translation address 'masquerade'
```
