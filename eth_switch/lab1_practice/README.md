# Lab Instructions
## Practicing with Ethernet Switches in containerlab & Illustrating a Network Diagram
### **Deploy the containerlab topology**

1. Launch the topology by running script deploy.sh
```
  bash deploy.sh
```
2. Sample output:
```
+---+--------------+--------------+--------------------------+-------+---------+----------------+-------------------
+
| # |     Name     | Container ID |          Image           | Kind  |  State  |  IPv4 Address  |   IPv6 Address    
|
+---+--------------+--------------+--------------------------+-------+---------+----------------+-------------------
+
| 1 | clab-lab2-h1 | f92f02bbb090 | docker.io/akpinar/alpine | linux | running | 172.20.0.21/24 | 2001:172:20::3/80 
|
| 2 | clab-lab2-h2 | 7ba192af6cc7 | docker.io/akpinar/alpine | linux | running | 172.20.0.22/24 | 2001:172:20::4/80 
|
| 3 | clab-lab2-h3 | b7a7d0cc8b58 | docker.io/akpinar/alpine | linux | running | 172.20.0.23/24 | 2001:172:20::5/80 
|
| 4 | clab-lab2-h4 | 356b638a4c8d | docker.io/akpinar/alpine | linux | running | 172.20.0.24/24 | 2001:172:20::2/80 
|
+---+--------------+--------------+--------------------------+-------+---------+----------------+-------------------
+
```
3. 
