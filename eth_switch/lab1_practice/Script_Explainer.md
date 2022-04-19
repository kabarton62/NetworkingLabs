# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Reading Bash Scripts
## Why Bother with this?

Although this is not a scripting course, you will see bash scripts. Additionally, you will need to read the scripts, perhaps modify scripts, and perhaps use commands that found in scripts. Therefore, you need some basic bash scripting skills.
## Let's talk _variables_
### Variables look stupid and are confusing. Why bother?

The two main reasons to use variables are:
1. To store data in descriptive terms that are easily understood.
2. To simply management of data that is used more than once.

The script **deploy.sh** uses a variable for the .yml file name. That file name (lab1.yml) is used multiple times in the script. The more times we use the same piece of data, the more opportunities we have to incorrectly call that data. Also, if we decide to change the file name, say from lab1.yml to stupid_lab.yml, we would have to find every instance where lab1.yml was used to update that file name to stupid_lab.yml if we were not using a variable. However, using a variable allows us to define that variable once and then call that variable everytime we need the file name after that. It is easier to manage. We would only have one place to update and the correct name would propogate to everyplace in the script that uses the file name.
### Defining and using variables
#### Defining variables

Three variables are defined at the beginning of deploy.sh. Note the variable name is on the left side of the equal sign, while the data placed in the variable is on the right side of the equal sign. 
```
br1="clab-br1"
br2="clab-br2"
f=lab1.yml
```
In this case, the variables are br1, br2 and f. The data placed in the three variables are text strings. The strings clab-br1 and clab-br2 are wrapped with double quotation marks. Quotation marks are required in some instances, such as if there was a space in the data, but in this instance those quotation marks are optional. The data placed in the variable f is not wrapped in quotation marks, and as you will note when running deploy.sh, all three variables function as expected.

A second variable type is used in deploy.sh. 
```
l=$(cat $f|grep name: | cut -d " " -f2)
```
The variable l contains the output from the command:
```
cat lab1.yml|grep name: | cut -d " " -f 2
```
The result from that command is **lab1**, so the variable l=lab1, but is assigned dynamically rather than statically. The variable could be assigned statically (l=lab1), but if the lab name got changed on line 20 of the script, the commands that depend on that data would fail unless we found and updated the data in the variable this variable. Assigning that variable dynamically reduces the chance that we will encounter this problem in the future.
#### Using variables
A variable is called in a bash script by the dollar sign and variable name. Examples to use the variables br1, br2, f and l:
```
$br1
$br2
$f
$l
```
### Creating a _here-document_
A here-document is a convenient way to write content to a file in a bash script. The script deploy.sh deploys a network lab using containerlab. That happens in line 56:
```
sudo clab deploy --topo $f

(which translates to the following after variables are resolved)

sudo clab deploy --topo lab1.yml
```
For the command to work, you need the file lab1.yml. That file could be provided separately, either in the GitHub repository or somewhere else, but an easier way to manage it is to create lab1.yml in this script. Lab1.yml is created in the script with a *here-document*. The here-document is created in lines 19 to 53. The following is a truncated copy of the here-document.
```
cat << EOF > $f

--- TRUNCATED CONTENT ---

EOF
```
You will recognize the variable $f. Recall that $f contains the string "lab1.yml". The command **cat << EOF > $f** will write the content of the here-document to lab1.yml. The value EOF on line 53 terminates the content of the here-document. Running the script deploy.sh creates a file in the current directory named lab1.yml with the content:
```
name: lab1
topology:
  defaults:
    kind: linux
  kinds:
    linux:
      image: docker.io/akpinar/alpine 
  nodes:
    h1:
      kind: linux
      mgmt_ipv4: 172.20.0.21
    h2:
      kind: linux      
      mgmt_ipv4: 172.20.0.22
    h3:
      kind: linux
      mgmt_ipv4: 172.20.0.23
    h4:
      kind: linux
      mgmt_ipv4: 172.20.0.24    
    clab-br1: 
      kind: bridge
    clab-br2: 
      kind: bridge
  links:
    - endpoints: ["h1:eth1", "clab-br1:eth13"]
    - endpoints: ["h2:eth1", "clab-br1:eth14"]
    - endpoints: ["h3:eth1", "clab-br2:eth15"]
    - endpoints: ["h4:eth1", "clab-br2:eth16"]
mgmt: 
  network: srl-mgmt
  ipv4_subnet: 172.20.0.0/24
  ipv6_subnet: 2001:172:20::/80  
```
That is easy to check. Run the script and look for lab1.yml in the same directory as deploy.sh. Note, we could write the file to any other location by including the full path to another directory.

### docker exec -it
Lines 71 through 74 configure IP addresses on hosts h1 through h4. The IP addresses are configured by running the following command, or similar, inside each host:
```
ip addr add 192.168.1.10/24 dev eth1
```
The catch is, those commands must be run inside the Docker containers h1 through h4, not on the machine hosting those Docker containers. Since h1 through h4 are Docker containers, an easy way to script this is to use the **docker exec** commmand. Docker exec allows us to execute a command inside container from the host without getting a shell or terminal in the container. The switch -it tells docker exec to run interactively. We do not really need interactive mode in this case, but it is habit, so it is included. So, the full command is:
```
sudo docker exec -it clab-lab1-h1 ip addr add 192.168.1.10/24 dev eth1
```
The string clab-lab1-h1 is the container name. Alternatively, we could use the container id in place of the container name, but we set the container name to make it easier to find specific containers.
So, let's look at the command being executed. The command **ip addr add** could read as **ip address add**. It configures an IP address to an interface. The IP address is 192.168.1.10 and the netmask is /24. The value /24 equals the value 255.255.255.0. Netmask and subnet mask are interchangeable terms. We will talk (much) more about subnet masks later. The last part **dev eth1** refers to the interface. The interface is eth1; dev eth1 is used to temporarily assign the IP address to eth1.

And that is a breakdown of deploy.sh.
