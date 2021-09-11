

user=$(whoami)
key0=MaxKeyEast2.pem

templateloc=/Users/$user/aws/createEC2_${user}.cf
keyfile=/Users/$user/aws/securitykey/$key0
ipfile=/Users/$user/aws/3ipaddress.txt
ipfile0=3ipaddress.txt

echo -n "" > $ipfile
echo "StrictHostKeyChecking no" >tmphost0
cat /etc/ssh/ssh_config tmphost0 | uniq >tmphost
sudo mv tmphost /etc/ssh/ssh_config


for mid in 0 1 2
#for mid in 8
do
	###  Step 0. Get the ip address
        stackname=zstack$mid
        ec2name=machine$mid
        infofile=infokeepFornewEC2_${stackname}_${ec2name}.txt
        echo "----- Stackname is: $stackname"
        echo "----- EC2Name is: $ec2name"
        echo "----- template is : $templateloc"

	sh U1_createEC2.sh $stackname $ec2name $templateloc
done

#####   Take a break and leave some time for the machines to be ready.
sleep 60
sh U0_gatherIPaddress.sh

#######
for mid in 0 1 2
do
        ### Step 1.0 
	machinename=machine${mid}
	#ipadr=$(cat infokeepFornewEC2_zstack${mid}_machine${mid}.txt)
	ipadr=$( grep $machinename $ipfile | cut -d" " -f1 )
        #echo "$ipadr machine$mid" >> $ipfile
        echo "---- Ip address is: $ipadr"
	echo "---- The machine name is: $machinename"
        #echo "yes" |  scp -i $keyfile $ipfile ubuntu@$ipadr:/home/ubuntu/
	#scp -i $keyfile -o StrictHostKeyChecking=no  $ipfile ubuntu@$ipadr:/home/ubuntu
	scp -i $keyfile $ipfile ubuntu@$ipadr:/home/ubuntu/ 

	###          Step 1. Some Setups..
	sed  "s/machineindex/machine$mid/" ztpl_Job2_SetupEC2_Remotejob.sh > Job2_SetupEC2_Remotejob.sh
	scp -i $keyfile Job2_SetupEC2_Remotejob.sh ubuntu@$ipadr:/home/ubuntu/ 	
	ssh -i $keyfile ubuntu@$ipadr sudo sh /home/ubuntu/Job2_SetupEC2_Remotejob.sh 
	
	###  Step 2. Set up the EC2 machines.
	echo "Step 2. ----- starting to copy the key over to id_rsa".
	scp -i $keyfile  $keyfile ubuntu@$ipadr:/home/ubuntu/.ssh/id_rsa
	echo "Step 2. ----- Completed copying the key over to id_rsa".

	###  Step 3. Make the machine keyless communnication.
	echo "Step 3. ----- starting to create hduser".
 	scp -i $keyfile Job3_create_hduser_withkey.sh ubuntu@$ipadr:/home/ubuntu/
        ssh -i $keyfile ubuntu@$ipadr sudo sh /home/ubuntu/Job3_create_hduser_withkey.sh
	echo "Step 2. ----- completed creating hdser".


	###  Step 4. Create user "hduse" nad make it keyless communicatable as well.
done


