# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Instructions
## Vyos Router Configuration
### Challenge 1: Network Topology

This lab deploys a network with three routers (r1, r2 and r3), and three Linux hosts (h1 thru h3). Table 1, Node Details and Table 2, Links provide details about node configuration and links between nodes. Illustrate the network design. 

**Save the network diagram illustration to a file named lab2_topology.jpg or lab2_topology.png.** 

The network diagram must include:
* All nodes and links between nodes
* Interface number (i.e., eth1, eth2) for each link termination
* IP address for each link termination
* Node name (i.e., r1, h1)

---

|Node|Interface|IP Address/Mask|
|---|---|---|
|h1|eth1|Discover IP & subnet from host|
|h2|eth1|Discover IP & subnet from host|
|h3|eth1|Discover IP & subnet from host|
|r1|eth1|First assignable IP address from h1:eth1|
|r1|eth2|First assignable IP address 10.0.0.0/30|
|r1|eth3|An assignable IP address 10.0.0.8/30|
|r2|eth1|First assignable IP address from h2:eth1|
|r2|eth2|Second assignable IP address 10.0.0.0/30|
|r2|eth3|An assignable IP address 10.0.0.4/30|
|r3|eth1|First assignable IP address from h3:eth1|
|r3|eth2|An assignable IP address 10.0.0.8/30|
|r3|eth3|An assignable IP address 10.0.0.4/30|

**Table 1, Node Details**

---

|Link Name|Endpoints|
|---|---|
|Lan 1|h1:eth1 -> r1:eth1|
|Lan 2|h2:eth1 -> r2:eth1|
|Lan 3|h3:eth1 -> r3:eth1|
|Link1|r1:eth2 -> r2:eth2|
|Link2|r1:eth3 -> r3:eth2|
|Link3|r2:eth3 -> r3:eth3|

**Table 2, Links**

--- 
## Operating the Lab Network
### Challenge 2: Deploy the Network
Launch the topology by running the script deploy.sh and **capture a screenshot of the results**.
```
  $ bash deploy.sh
```
--- 
## Configure the Network
### Challenge 3: Collect & Report Host Configuration Data

Examine hosts h1 through h3. Complete Table 3, Host Configuration.

|Host|IP Address|Subnet Mask|First Assignable IP|Last Assignable IP|
|---|---|---|---|---|
|H1|||||
|H2|||||
|H3|||||

**Table 3, Host Configuration**

---
### Challenge 4: Configure Node Interfaces and Test Link Operation
"Node" refers to hosts h1 through h3 and routers r1 through r3. Based on the information provided in Table 1 and collected for Table 3, configure IP address and subnet mask on all node interfaces. If node interfaces are correctly configured, pings across the links described in Table 2 will be successful. Test each link. Troubleshoot and resolve any failed links. Complete Table 4, Link Test Results to report successful link tests.

|Link Name|Source Node|IP on Relevant Source Node Interface|Ping Command used to Test Link|Response Time|
|---|---|---|---|---|
|Lan 1|||||
|Lan 2|||||
|Lan 3|||||
|Link1|||||
|Link2|||||
|Link3|||||

**Table 4, Link Test Results**

### Challenge 5: Configure Static routes 
Because the network does not use routing protocols to dynamically learn routes, static routes are required to enable communications between all node interfaces. In this case, one default route will be configured on each router. Configure the default routes as described in Table 5, Default Routes.

|Node|Default Route Next-hop|
|---|---|
|r1|r3:eth2|
|r2|r1:eth2|
|r3|r2:eth3|

**Table 5, Default Routes**

### Challenge 6: Test Network Operation
All node interfaces should be able to communicate at this point. Complete the following **ping** tests to demonstrate network operation. Report results in Table 6, Network Test Results. All pings should be successful. Troubleshoot and correct any failed ping tests.

|Source Node|Destination Node:Interface|Ping Command used to Run Test|Response Time|
|---|---|---|---|
|h1|h2:eth1|||
|h1|h3:eth1|||
|h2|r1:eth3|||
|h2|r3:eth2|||
|h3|r1:eth3|||
|h3|r2:eth2|||

**Table 6, Network Test Results**

---
## Understanding the Network
### Challenge 6: Examine Routes 
You created a network diagram at the beginning of the lab. Use that diagram to predict the routes between the nodes in Table 6, Predicted Hops between Nodes. **Complete Table 7, Predicted Routes. Include router interfaces on router hops**.

|Source|Destination|Hops (Example for h1 -> h2: h1, r1:eth1, r2:eth2, h2)|
|---|---|---|
|h1|h2||
|h1|h3||
|h2|h1||
|h2|h3||
|h3|r1:eth3||

**Table 7, Predicted Routes**

### Challenge 7: Test Routes with TRACEROUTE
You attempted to predict routes between nodes. Now, use **traceroute** to test network function. Traceroute between the nodes and report the hops in the same format as in the previous challenge. **Report observed routes in Table 8, Observed Routes**.

|Source|Destination|Hops (Example for h1 -> h2: h1, r1:eth1, r2:eth2, h2)|
|---|---|---|
|h1|h2||
|h1|h3||
|h2|h1||
|h2|h3||
|h3|r1:eth3||

**Table 8, Observed Routes**

### Challenge 8: Compare Predicted Routes to Observed Routes
Compare your predicted routes between the nodes in Challenge 6 to the observed routes in Challenge 7. Did the predicted and observed routes match? If not, attempt to explain the difference. If so, discuss how you were able to predict the correct correct routes.

### Challenge 9: Report Router Configuration
If configurations have not been saved on r1, r2, and r3, save the configuration on all routers. Show configuration on all routers, copy and paste those configurations into separate documents. Name the documents with the router configurations **r1.conf, r2.conf, and r3.conf**.
