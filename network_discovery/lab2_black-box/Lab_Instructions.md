<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# Lab Instructions: Network Discovery
## Operating the Lab Network
### Challenge 1: Deploy the Lab Network
Launch the topology by running the script deploy.sh and manually launch the http service on the web server.
```
  $ bash deploy.sh
```
--- 
## Discovering hosts and enumerating services
### Challenge 2: SSH to the Containerlab server

SSH-RSA keys, username and IP address are provided separately. Use those resources to gain access to the containerlab server. 

Once connected to the containerlab server connect to H1 using the id_rsa key found in the student's home directory. 
```
ssh -i id_rsa student@clab-lab2-h1 -p 2222
``` 
**NOTE:** The user *student* on h1 does not have history. That is deliberate. All students will share the same user, so history was excluded. The user also does not have bash completion so all commands must be typed fully.

### Challenge 3: Network discovery

Examine /etc/hosts on H1 to discover hosts in the demo.us domain. Fully enumerate router links, IP addresses on the router interfaces, and services on the demo.us domain servers. 

### Challenge 4: Network diagram
**Using the information collected, diagram the network from H1 to all hosts in demo.us. Include IP addresses as fully as possible on the router interfaces. Report service versions on all demo.us servers.**

---
## Exploiting Vulnberable Services
### Challenge 5: BONUS (10 PTS)
One server in demo.us has a Local File Inclusion (LFI) vulnerability with a public exploit on https://exploit-db.com. Discover the vulnerability and exploit, then demonstrate exploiting the LFI vulnerability by reading /etc/passwd on the vulnerable server using the LFI exploit.

**Capture a screenshot of the /etc/passwd file on the vulnerable server.**

### Challenge 6: BONUS (10 PTS)
The server discovered in Challenge 5 is also vulnerable to Remote Code Execution (RCE). Using the exploit discovered in Challenge 5 demonstrate the RCE exploit by executing the **id** command.

**Capture a screenshot showing the results of the id command on the vulnerable server.**
