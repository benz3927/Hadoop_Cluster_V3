user=maxzhao
ipfile="/Users/${user}/aws/3ipaddress.txt"

aws ec2 describe-instances \
  --filter "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].[PublicIpAddress, Tags[?Key=='Name'].Value|[0]]" \
  --output text | awk '{FS="\t";  OFS=" "} {print $1,$2}' | sed 's/\t/ /g' | sed 's/ \+/ /g'  >$ipfile



