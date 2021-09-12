
user=$(whoami)
key0=BenKey.pem

templateloc=/Users/$user/aws/createEC2_${user}.cf
keyfile=/Users/$user/aws/securitykey/$key0
ipfile=/Users/$user/aws/3ipaddress.txt
ipfile0=3ipaddress.txt

echo -n "" >  $ipfile0

for idx in  4 5 6 
#for idx in  8
do
	echo "-----  Working on machine $idx"
	stackname=zstack$idx
	ec2name=machine$idx	
	infofile=infokeepFornewEC2_${stackname}_${ec2name}.txt
	
	sh U1_createEC2.sh $stackname $ec2name $templateloc

	ipadr=$(cat $infofile)
	echo "$ipadr machine$idx" >>$ipfile0

done

