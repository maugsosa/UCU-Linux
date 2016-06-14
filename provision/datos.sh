#!/bin/sh
exec sudo su - << eof
grep -q -F '10.0.0.210 server' /etc/hosts || echo '10.0.0.210 server' >> /etc/hosts
grep -q -F '10.0.0.223 control' /etc/hosts || echo '10.0.0.223 control' >> /etc/hosts
export DEBIAN_FRONTEND=noninteractive
#sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password rootpass'
#sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password rootpass'
apt-get update
apt-get install -y mysql-server mysql-client
useradd operador -p password
echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
usermod -aG wheel operador
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
sed -i 's/^#?Port .*/Port 4000/' /etc/ssh/sshd_config
systemctl restart ssh
echo "CREATE DATABASE wordpress;" | mysql -u root -ppassword
ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""
cat /tmp/sshkey.pub >>~/.ssh/authorized_keys
chmod 700 ~/.ssh/authorized_keys
scp /tmp/sshkey reapaldo@control:/home/.ssh/datos
eof