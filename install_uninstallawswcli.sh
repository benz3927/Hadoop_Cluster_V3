


#####  How to install awscli most recent version

 curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
 sudo installer -pkg AWSCLIV2.pkg -target /

#### Install awscli specific version
$ curl "https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg" -o "AWSCLIV2.pkg"
$ sudo installer -pkg AWSCLIV2.pkg -target /


#####   Step 2. How to uninstall awscli.
which aws

ls -l /usr/local/bin/aws

sudo rm /usr/local/bin/aws

sudo rm /usr/local/bin/aws_completer

sudo rm -rf /usr/local/aws-cli
