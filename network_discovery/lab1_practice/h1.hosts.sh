#!/bin/bash
cat << EOF > /h1.hosts
  GNU nano 6.2                   /etc/hosts *                           
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.20.0.4      h1
2001:172:20::4  h1
10.150.1.99     duck.vitty.us   
10.200.1.22     lizard.vitty.us
10.200.1.88     snake.vitty.us
10.200.1.16     frog.vitty.us
EOF

cp /h1.hosts /etc/hosts
rm /h1.hosts
cat /etc/hosts
