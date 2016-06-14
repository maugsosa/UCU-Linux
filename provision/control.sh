#!/bin/sh
​
exec sudo su - << eof
​
grep -q -F '10.0.0.222 datos' /etc/hosts || echo '10.0.0.222 datos' >> /etc/hosts
grep -q -F '10.0.0.210 server' /etc/hosts || echo '10.0.0.210 server' >> /etc/hosts

useradd respaldo -m
​
useradd operador -p password
​
echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
​
usermod -aG wheel operador
​
mkdir /home/respaldo/.ssh
​

​
echo "Host server
    HostName server
    User root
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/server" >> /home/respaldo/.ssh/config
​
echo "Host datos
    HostName datos
    User root
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/control" >> /home/respaldo/.ssh/config

 
  echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
​
chown -R respaldo /home/respaldo/.ssh


eof
