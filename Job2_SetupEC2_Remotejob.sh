#####   Set up EC2.
machinename=machine2
ipaddress=ipaddressValue

ipfile=3ipaddress.txt

###  Step 1.  Change the hostname file.
sudo cp /etc/hostname /etc/hostname.zkeep
sudo sed -i "1 s/^.*$/$machinename/" /etc/hostname

###  Step 2.2  Change the hosts file.
sudo cp /etc/hosts /etc/hosts.zkeep
sudo sed -i "2 i\127.0.1.1 $machinename"  /etc/hosts

###  Step 2.2  Change the hosts file.
sudo cat  $ipfile >> /etc/hosts

