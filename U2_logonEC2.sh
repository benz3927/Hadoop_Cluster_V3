user=$(whoami)
key0=BenKey.pem

keyfile=/Users/$user/aws/securitykey/$key0
ipfile=/Users/$user/aws/3ipaddress.txt

#######
if [ $# -eq 1 ]; then
	loginuser=ubuntu
	echo "---- mid is: $1"
	echo "---- Default loginuser is: ubuntu"
elif [ $# -eq 2 ]; then
	echo "---- mid is: $1"
	echo "---- Default loginuser is: $2"
else
     echo "Incorrect parameters"
     echo "$0 [machineindex][loginuser]"
     exit 2

fi

######
mid=$1
loginuser=$2
echo "The machine name is: machine$mid"


####
#ipadr=$(grep machine${mid} $ipfile | cut -d" " -f1)
#echo "---- Ip address is: $ipadr"

ipadr=$(grep machine${mid} $ipfile | cut -d" " -f1 | sed 's/\./-/g')
ec2link="ec2-$ipadr.us-east-2.compute.amazonaws.com"

#ssh -i $keyfile $loginuser@$ipadr
ssh -i $keyfile $loginuser@$ec2link

