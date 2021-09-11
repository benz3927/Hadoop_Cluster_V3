
#######################   Step 0. 1  Set up the time.
sudo timedatectl set-timezone EST

#######################   Step 0. 2  Install Java .   -----  do this for all machines
sudo apt-get update  ##   Run this before running the openjdk-7-jdk
echo yes | sudo apt-get install  openjdk-8-jdk

#######################   Step 1.  Download and Install the Hadoop.
cd ~
hdpversion="3.3.1"
wget http://apache.mirrors.lucidnetworks.net/hadoop/common/hadoop-${hdpversion}//hadoop-${hdpversion}.tar.gz
sudo tar zxf hadoop-${hdpversion}.tar.gz 

cd ~
sudo chown -R hduser:hadoop  hadoop-${hdpversion}

