#
# Update sources.list
#
sudo mv /etc/apt/sources.list /etc/apt/sources.list.old

sudo echo "deb http://ftp.sjtu.edu.cn/ubuntu/ trusty universe restricted multiverse main
deb http://ftp.sjtu.edu.cn/ubuntu/ trusty-security universe restricted multiverse main
deb http://ftp.sjtu.edu.cn/ubuntu/ trusty-updates universe restricted multiverse main
deb http://ftp.sjtu.edu.cn/ubuntu/ trusty-proposed universe restricted multiverse main
deb http://ftp.sjtu.edu.cn/ubuntu/ trusty-backports universe restricted multiverse main" > /etc/apt/sources.list

sudo apt-get update

#
# Set hostname and hosts
#
sudo echo "node1" > /etc/hostname
sudo echo "192.168.6.18 node1
192.168.6.15 node2
192.168.6.16 node3" >> /etc/hosts

ssh sk@192.168.6.15
sudo echo "node2" > /etc/hostname
sudo echo "192.168.6.18 node1
192.168.6.15 node2
192.168.6.16 node3" >> /etc/hosts
exit

ssh sk@192.168.6.16
sudo echo "node3" > /etc/hostname
sudo echo "192.168.6.18 node1
192.168.6.15 node2
192.168.6.16 node3" >> /etc/hosts
exit

#
# Set ssh
#
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.15
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.16

# Go to node2
ssh sk@node2
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.18
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.16
exit

# Go to node3
ssh sk@node3
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.18
ssh-copy-id -i ~/.ssh/id_rsa.pub sk@192.168.6.15
exit

# Install Oracle JDK 8
sudo apt-get install python-software-properties -y
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

#
# Vim
#
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

#
# Spark configuration
# http://spark.apache.org/downloads.html
#

# Download pre-build Spark with user-provided Hadoop
wget http://www.apache.org/dyn/closer.lua/spark/spark-1.5.2/spark-1.5.2-bin-without-hadoop.tgz －O spark.tgz
tar xvzf spark.tgz && cd spark

# Setup slaves
# https://spark.apache.org/docs/latest/spark-standalone.html
cd conf && cp slaves.template slaves
echo "node3" > slaves

# Start master
./sbin/start-all.sh
