# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Routing Labs
## Practice
This lab includes four hosts. Hosts h1 and h2 are in the same network, connected to the same switch. Therefore, they can pass traffic to each other. Hosts h3 and h4 are in a different network, connected to a different switch. Hosts h3 and h4 can also pass traffic to each other, but h1 and h2 cannot communicate with h3 and h4 without a router. The topology includes two routers, r1 and r2. Routers r1 and r2 are not configured and therefore cannot forward packets from the two networks as initially deployed.

This lab uses common network utilities, such as **ping, traceroute, route, ifconfig, etc**, to test and troubleshoot network operation. After examining network function with the unconfigured routers, the lab configures the interfaces connected to each network and the interfaces that link r1 and r2. Additional network testing follows. Finally, the lab configures static routes on r1 and r2, then tests network function once again.

## Router Configuration
Lab 2 Configuration builds upon the skills practiced in Lab 1 Practice. Given a basic network topology and a network with hosts, routers, switches and connections, the lab challenges the user to configure the routers to enable all hosts to communicate. 

## Vyos Documentation
These labs use Vyos router Docker containers. A Vyos User Guide can be found [here](https://docs.vyos.io/en/latest/configuration/index.html). Basic commands needed for these labs are included in the practice lab instructions but refer to Vyos documentation for additional assistance. 
