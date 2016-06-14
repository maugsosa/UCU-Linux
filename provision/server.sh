#!/bin/bash

exec sudo su - << eof

grep -q -F '10.0.0.223 control' /etc/hosts || echo '10.0.0.223 control' >> /etc/hosts
grep -q -F '10.0.0.222 datos' /etc/hosts || echo '10.0.0.222 datos' >> /etc/hosts

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y install apache2

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi


apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc php5-cli > /dev/null 2>&1


curl -O https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
cd wordpress
cp -rf . ..
cd ..
rm -R wordpress
cp wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/wordpress/g" wp-config.php
perl -pi -e "s/username_here/root/g" wp-config.php
perl -pi -e "s/password_here/wordpress/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

mkdir wp-content/uploads
chmod 775 wp-content/uploads
rm latest.tar.gz
rm wp.sh



useradd operador -p password
echo "%wheel        ALL=(ALL)       ALL" >> /etc/sudoers
usermod -aG wheel operador
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
sed -i 's/^#?Port .*/Port 4000/' /etc/ssh/sshd_config
systemctl restart ssh

ssh-keygen -b 2048 -t rsa -f /tmp/sshkey -q -N ""
cat /tmp/sshkey.pub >>~/.ssh/authorized_keys
chmod 700 ~/.ssh/authorized_keys

scp /tmp/sshkey reapaldo@control:/home/.ssh/server 

eof


