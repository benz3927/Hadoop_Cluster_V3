#!/bin/bash

#############################################################################################################
###
###     3 Input parametersi:  1) stackname,   2) ec2name and 3) cf template name.
###
###	2 Output:
###		1) New EC2.
###		2) EC2 info kept in the file: infokeep_newEC2_${ec2name}.txt
###
###
#############################################################################################################

if [ $# -ne 3 ]; then
     echo "Incorrect parameters"
     echo "$0 [stackname][EC2instancename][templateloc]"
     exit 2
fi

stackname=$1
ec2name=$2
templatefile=$3
templateloc="file://$templatefile"

logfile=U1_createEC2.log
echo -n "" >$logfile

#templateloc=file:///Users/maxzhao/aws/dockerizedjob/test.cf
echo "-------  Input 1: The stackname is:  $stackname"         2>&1 | tee -a $logfile
echo "-------  Input 2: The EC2 Instance name is:  $EC2Name"   2>&1 | tee -a $logfile
echo "-------  Input 3: The templae file is:  $templateloc"    2>&1 | tee -a $logfile


########  Step 0. Read in the parameters.
cp $templatefile $templatefile.zkeepold
sed -i.bu 's/Value: .*$/Value: '"${ec2name}"'/g' $templatefile


#######   Step 1.  Start to generate the instance,
echo "------- Step 1. Starting to generate the stack."    2>&1 | tee -a $logfile
aws cloudformation create-stack  --stack-name "$stackname" \
	--template-body "$templateloc" 

echo "------- Step 1. Completed generating the stack."    2>&1 | tee -a $logfile

#######   Step 2. Keep the Name, the imageid and the privateID of the instance.
infofile=infokeepFornewEC2_${stackname}_${ec2name}.txt 
rm -rf $infofile

echo "------- Step 2. Starting to check the instance creation."    2>&1 | tee -a $logfile

iter=0
while true

do
        iter=$(( 1+ $iter ))
        echo "---- iter = $iter, Time Stamp: $(date)."    2>&1 | tee -a $logfile
	tip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$ec2name" \
			--query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
	echo $tip

        if [[ ! -z "$tip" ]]; then
                echo $tip | sed '/^[[:space:]]*$/d' > $infofile
                echo "----  IP found. exiting."   2>&1 | tee -a $logfile
                break
        fi
        sleep 1
done

echo "------- Step 2. Completed checking the instance creation."    2>&1 | tee -a $logfile

#######  Step 3. check to see if there are any results generated.
nip=$(wc -l $infofile | awk '{print $1}')
if [ "$nip" -eq "1" ]; then
        echo "-----  Great. The private iP address was captured."   2>&1 | tee -a $logfile
else
        echo "-----  Empty file or 2 plus lines in the ipfile."     2>&1 | tee -a $logfile
        #exit 2
fi


#######   Step 2.1 Describe the stack.
#aws cloudformation describe-stacks --stack-name $stackname

#######   Step 2.2 Delete the stack.  Roll back the
#aws cloudformation delete-stack --stack-name $stackname

