<img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="200" height="100"> 

# NetworkingLabs
These networking labs use Docker and Containerlab for students, and whoever else wants to use these labs, easy to deploy computer networking labs.

## Part 1, Ethernet Switching [eth_switch labs](https://github.com/kabarton62/NetworkingLabs/tree/main/eth_switch)

Ethernet switching labs use Linux bridges to simulate basic switch function. Frames are forwarded between hosts using TCP/IP Layer 2 functions in Linux bridges. These labs connect hosts to isolated bridges, simulating stand-alone Ethernet switches. Hosts connected to a single switch are capable of communicating, but hosts cannot communicate with hosts connected to other switches. Bash scripts are provided that deploy and destroy the lab network in Containerlab.

## Part 2, Router Basics [router_basic labs](https://github.com/kabarton62/NetworkingLabs/tree/main/router_basic)
Router basics labs add open source Vyos routers to route traffic between two local networks. The switching technology introduced in Ethernet switching labs is used in these labs to create the local networks, but two routers are added to the network to connect the two local networks. The practice lab demonstrates basic interface and static route configurations needed to make the topology work. Bash scripts are provided that deploy and destroy the lab network in Containerlab.

## Part 3, Troubleshooting Routing [router_troubleshooting labs](https://github.com/kabarton62/NetworkingLabs/tree/main/router_troubleshooting)
Students may make errors when configuring routers and routing protocols. These labs deploy routers with intentional configuration errors and introduce a method to troubleshoot and correct those errors. Students practice isolating and correcting conf 

## Part 4, Routing Protocols [routing_protocols labs](https://github.com/kabarton62/NetworkingLabs/tree/main/routing_protocols)
An 8-router network is deployed. RIP and OSPF are configured to enable dynamic route learning throughout the network. 

## Part 5, Network Services [network_services labs](https://github.com/kabarton62/NetworkingLabs/tree/main/network_services)
Students configure NAT, DHCP and DNS services in the network. Interfaces and routing protocols are pre-configured on the Vyos routers and end points are pre-configured as DHCP clients. The network also includes a web and two DNS servers to support network service configuration and testing.

## Part 6, Network Discovery [network_discovery labs](https://github.com/kabarton62/NetworkingLabs/tree/main/network_services)
This lab practices collecting network configuration data using various methods, such as DNS queries and network scans. Students analyze that data and create a network diagram that illustrates the network topology and configuration details. 
