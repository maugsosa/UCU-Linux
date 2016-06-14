#!/bin/bash

grep -q -F '10.0.0.222 router' /etc/hosts || echo '10.0.0.222 router' >> /etc/hosts
sudo apt-get install mysql-server




#Nico
#!/bin/sh
​
exec sudo su - << eof
​
echo '10.0.0.210 server' >> /etc/hosts
echo '10.0.0.223 control' >> /etc/hosts
​
useradd operador -p password
​
echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
​
usermod -aG wheel operador
​
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
​
​
sed -i 's/^#?Port .*/Port 4000/' /etc/ssh/sshd_config
​
systemctl restart ssh
​
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get -y install mysql-server
​
echo "CREATE DATABASE wordpress;" | mysql -u root -ppassword
​
eof
