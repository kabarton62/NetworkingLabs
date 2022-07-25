# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Network Discovery

## Operating the Lab Network
### Challenge 1: Deploy the Lab Network
Launch the topology by running the script deploy.sh and manually launch the http service on the web server.
```
  $ bash deploy.sh
  $ sudo docker exec -it clab-lab1-web /httpd.sh

Confirm that you can browse to the web server
  
  $ sudo docker exec -it clab-lab1-web ifconfig eth0
  $ curl http://<web eth0 ip address>
```
--- 
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

## Challenge 3: nmap: Port Scanning

Before we jump into nmap, you might be curious how **ping** discovered the IP addresses of the target hosts if DNS is not configured. After all, DNS is the service used to resolve hostnames to IP addresses and DNS services were not configured in this network. The answer lies in the fact that DNS is not the only mechanism used for name resolution.

Operating systems such as Windows, MacOS and Linux include a file to resolve local IP addresses. By default, /etc/hosts includes IP addresses for the host machine, but additional hostnames can be added to the file. Hosts check /etc/hosts first to resolve addresses. If an answer is not found in /etc/hosts, the host queries DNS for name resolution.

Curios where the hostnames in Challenge 2 were resolved? Inspect /etc/hosts on H1.

Now, let's talk to **nmap**. Nmap scans single hosts, groups of hosts, or subnets, to discover the state of TCP and UDP ports. Advanced functions of nmap can be used to identify operating systems, service versions, increase scan stealth, and use Nmap Scripting Engine (NSE) to scan for various service or configuration vulnerabilities.

### Default scan

Nmap's default scan employs a half-open SYN scan (SYN, SYN/ACK ... but omits the client ACK), 1,000 common TCP ports (no UDP ports; not the first 1,000 ports, but the most common 1,000 ports), and excludes service version or operating system detection. Executing a default scan is simple: just run nmap without additional options. For example, the following command runs a default nmap scan against 192.168.1.0/24:
```
nmap 192.168.1.0/24
```
In Challenge 2, you discovered 5 hosts in vitty.us domain. **Add that list of IP addresses to a file, such ip-list.txt, and run a default scan against those IP addresses from H1.** The -iL option directs nmap to scan a list of IP addresses from a file.

Do you want a shortcut to get that IP list? Recall that those IP addresses came from /etc/hosts. The **grep** and **cut** commands can extract those IP addresses from /etc/hosts. Filter the list for lines that include the domain vitty.us (grep vitty) then **cut** those lines to extract just the IP addresses. The **cut** command use a space as a delimiter (-d " ") and takes the first field (-f 1), the writes the output to a file (> ip-list).
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

Nmap's **-sV** option attempts to enumerate services on discovered open ports, to include the version of that service. In the above example where an administrator configured ssh to listen on TCP, the following command would scan TCP 80 for the service version and return a result such as:
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
