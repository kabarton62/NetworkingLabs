# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
# Network Discovery
## Operating the Lab Network
### Challenge 1: Deploy the Lab Network
Launch the topology by running the script deploy.sh and manually launch the http service on the web server.
```
  $ bash deploy.sh
```
--- 
## Discovering hosts and enumerating services
### Challenge 2: Host Discovery

This labs deploys a network with routers, servers, and one client (H1). H1 includes a suite of networking tools that users can deploy to discover the servers and network topology. Table 1, Hostnames provides a place to documment server information.

|Hostname| ___ IP Address ___ |
|---|---|
|duck.vitty.us||
|lizard.vitty.us||
|snake.vitty.us||
|frog.vitty.us||

**Table 1, Hostnames**

Name servers are not configured on H1, so **dig** and **nslookup** commands cannot not resolve the hostnames from Table 1. However, **ping** will successfuly resolve those hostnames.

In the following example, the IP address for varmint.myhome.com is 105.90.1.77.

```
root@h1:/# ping varmint.myhome.com
  PING varmint.myhome.com (105.90.1.77) 56(84) bytes of data.
  64 bytes from varmint.myhome.com (105.90.1.77): icmp_seq=2 ttl=62 time=0.157 ms
```
**Use ping to resolve IP addresses for the hosts in Table 1. Record the IP addresses for each host.** 

--- 
### Challenge 3: nmap: Port Scanning

Before we jump into nmap, you might be curious how **ping** discovered the IP addresses of the target hosts if DNS is not configured. After all, DNS is the service used to resolve hostnames to IP addresses and DNS services were not configured in this network. The answer lies in the fact that DNS is not the only mechanism used for name resolution.

Operating systems such as Windows, MacOS and Linux include a file to resolve local IP addresses. By default, /etc/hosts includes IP addresses for the host machine, but additional hostnames can be added to the file. Hosts check /etc/hosts first to resolve addresses. If an answer is not found in /etc/hosts, the host queries DNS for name resolution.

Curios where the hostnames in Challenge 2 were resolved? Inspect /etc/hosts on H1.

Now, let's talk to **nmap**. Nmap scans single hosts, groups of hosts, or subnets, to discover the state of TCP and UDP ports. Advanced functions of nmap can be used to identify operating systems, service versions, increase scan stealth, and use Nmap Scripting Engine (NSE) to scan for various service or configuration vulnerabilities.

### Default scan

Nmap's default scan employs a half-open SYN scan (SYN, SYN/ACK ... but omits the client ACK), 1,000 common TCP ports (no UDP ports; not the first 1,000 ports, but the most common 1,000 ports), and excludes service version or operating system detection. Executing a default scan is simple: just run nmap without additional options. For example, the following command runs a default nmap scan against 192.168.1.0/24:
```
nmap 192.168.1.0/24
```
In Challenge 2, you discovered 4 hosts in the vitty.us domain. **Add that list of IP addresses to a file, such ip-list.txt, and run a default scan against those IP addresses from H1.** The -iL option directs nmap to scan a list of IP addresses from a file.

Do you want a shortcut to get that IP list? Recall that those IP addresses came from /etc/hosts. The **grep** and **cut** commands can extract those IP addresses from /etc/hosts so they can be written directly to a file. Filter /etc/hosts for lines that include the domain vitty.us (grep vitty) with **grep** then **cut** those lines to extract just the IP addresses. The following **cut** command uses a space as a delimiter (-d " ") and takes the first field (-f 1), the writes the output to a file (> ip-list).
```
cat /etc/hosts | grep vitty | cut -d " " -f 1 > ip-list.txt
```
Now, run a default scan against the IP addresses in ip-list.txt.

Want to see the results as they are discovered? Include the **-v** option.
```
nmap -iL ip-list.txt
nmap -iL ip-list.txt -v
```

### Service version and all ports scan
The default nmap scan will report the assigned version on discovered open ports (i.e., http for TCP 80, nfs for TCP 2049, etc). Those may or may not be the actual service running on the open port. For example, an administrator could configure ssh on TCP 80. The default scan would detect port 80 open and report http on that port.

Nmap's **-sV** option attempts to enumerate services on discovered open ports, to include the version of that service. In the above example where an administrator configured ssh to listen on TCP 80, the following command would scan TCP 80 for the service version and return a result such as:
```
nmap localhost -sV -p 80
  Starting Nmap 7.80 ( https://nmap.org ) at 2022-07-25 12:51 UTC
  Nmap scan report for localhost (127.0.0.1)
  Host is up (0.00023s latency).

  PORT   STATE SERVICE VERSION
  80/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.4 (Ubuntu Linux; protocol 2.0)
  Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
  Nmap done: 1 IP address (1 host up) scanned in 0.50 seconds
```

**Scan and report service versions for open ports on the hosts in the vitty.us domain.**

The option **-p-** can be included to scan all ports. Recall that the default scan tests only the most common 1,000 ports. A host may have open ports that are not in that set of *most common ports*. Those ports would not be scanned by the default scan and therefore not detected. The **-p-** option would scan and detect all open ports.

--- 
## Enumerating Paths
### Challenge 4, traceroute
Traceroute uses pings with an incrementing time-to-live (TTL) value to discover hops in the path from one host to another. Each device that handles a packet decrements the TTL value by one. If the TTL value decreases to 0, the device that decremented the TTL value to 0 will send a time-out error to the source host. Traceroute starts with a TTL value of 1 in the first ping packet. The Default Gateway would decrement the TTL from 1 to 0, triggering a time-out error. The Default Gateway would then send a time-out error to the source host. The source host notes the IP address of the node sending that error and reports it as the first hop.

The TTL value is then increased by 1. As a result, the second hop would decrement the TTL to 0 and send the time-out error. The TTL value would continue to be incremented by one until the ICMP packet reaches to the destination host.

Now, let's add a little nuance to the process. *Hops* are generally routers, and each hop would normally have two interfaces handle each packet. The ingress interface would receive the packet and the egress interface would send the packet to the next hop. Although the router may have two interfaces handle the packet, **only one interface per router will respond**. 

In most cases, the responding interface will be the ingress interface. In other words, the interface that first receives the packet will normally respond to a traceroute. The exception is when the destination IP address is a router interface. When the destination IP address is a router interface,  that interface will respond. This nuance can be used to discover IP addresses on router interfaces. 

Consider traceroutes from H1 to the IP address 10.200.1.16 and 10.200.1.1:

```
traceroute 10.200.1.16
  traceroute to 10.200.1.16 (10.200.1.16), 30 hops max, 60 byte packets
   1  10.100.1.1 (10.100.1.1)  0.175 ms  0.042 ms  0.026 ms
   2  10.0.0.2 (10.0.0.2)  0.085 ms  0.047 ms  0.032 ms
   3  10.0.0.6 (10.0.0.6)  0.087 ms  0.050 ms  0.037 ms
   4  frog.vitty.us (10.200.1.16)  0.191 ms  0.117 ms  0.069 ms
   
traceroute 10.200.1.1
  traceroute to 10.200.1.1 (10.200.1.1), 30 hops max, 60 byte packets
   1  10.100.1.1 (10.100.1.1)  0.092 ms  0.020 ms  0.016 ms
   2  10.0.0.2 (10.0.0.2)  0.054 ms  0.021 ms  0.018 ms
   3  10.200.1.1 (10.200.1.1)  0.062 ms  0.028 ms  0.025 ms
```
Notice that hops 1 & 2 are the same, but that hop 3 is different for the two tracerotues. From the traceroute to 10.200.1.1 it might be tempting to conclude that 10.200.1.1 is the next-hop from the router with 10.0.0.2, but that would be wrong. Note that 10.200.1.16 and 10.200.1.1 are in the same network (10.200.1.0/24). IP address 10.0.0.6 is the next-hop from 10.0.0.2, and 10.200.1.1 is the Default Gateway to 10.200.1.0/24. 10.0.0.6 and 10.200.1.1 are different interfaces on the same router. The ingress interface is 10.0.0.6 and the egress interface is 10.200.1.1.

We can use this technique to enumerate router interfaces, with one caveat. Traceroute can only be run against one IP address at a time. You cannot scan a range of IP addresses in a single command. However, nmap supports traceroutes and can conduct traceroute to an IP address range.

Consider the following example:
```
nmap --traceroute 10.200.1.0/24
Starting Nmap 7.80 ( https://nmap.org ) at 2022-07-25 19:50 UTC
Nmap scan report for frog.vitty.us (10.200.1.16)

TRACEROUTE (using port 993/tcp)
HOP RTT     ADDRESS
-   Hops 1-3 are the same as for 10.200.1.22
4   0.05 ms frog.vitty.us (10.200.1.16)

Nmap scan report for lizard.vitty.us (10.200.1.22)

TRACEROUTE (using port 993/tcp)
HOP RTT     ADDRESS
1   0.11 ms 10.100.1.1
2   0.22 ms 10.0.0.2
3   0.04 ms 10.0.0.6
4   0.06 ms lizard.vitty.us (10.200.1.22)

Nmap scan report for 10.200.1.1
Host is up (0.000038s latency).
All 1000 scanned ports on 10.200.1.1 are closed

TRACEROUTE (using port 993/tcp)
HOP RTT     ADDRESS
-   Hops 1-2 are the same as for 10.200.1.22
3   0.03 ms 10.200.1.1
```
The nmap results are truncated to just show the traceroute results. Note that the results for 10.200.1.22 show all of the hops, but that the results for 10.200.1.16 and 10.200.1.1 note which hops are duplicates with 10.200.1.22 and only show newly discovered hops. We can use this nuance to identify the Default Gateway to a network. The Default Gateway will have one less hop in the path.

**Scan the networks that conatin the hosts in the vitty.us domain. You may have to guess on subnet mask. Report the Default Gateway of each target network in Table 2. This same technique can be used to identify IP address on each end of a link between routers.**

|Hostname|Default Gateway|
|---|---|
|duck.vitty.us||
|lizard.vitty.us||
|snake.vitty.us||
|frog.vitty.us||

**Table 2, Default Gateways**

### Challenge 6, Network diagram
**Using the information collected, diagram the network from H1 to all hosts in vitty.us. Include IP addresses as fully as possible on the router interfaces.**
