
###  Step 1. Add user/
sudo adduser --disabled-password --gecos "" hduser 
sudo adduser hduser sudo 

###  Step 2. Copy the keys.
sudo rm -rf /home/hduser/.ssh
sudo cp -r /home/ubuntu/.ssh /home/hduser/.ssh
sudo chown  hduser:hduser /home/hduser/.ssh -R

