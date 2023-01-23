#!/bin/bash

# Install requirred tools
yum install -y wget zip unzip
yum install -y java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64

# Install JMeter
cd /tmp
wget --no-check-certificate  https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.5.zip
unzip apache-jmeter-5.5.zip
mv apache-jmeter-5.5 /usr/local/jmeter

# Modify JMeter setting
cd /usr/local/jmeter/bin
sed -i -e "s/#*server\.rmi\.ssl\.disable/server\.rmi\.ssl\.disable/" user.properties
sed -i -e "s/server\.rmi\.ssl\.disable=false/server\.rmi\.ssl\.disable=true/" user.properties

# Add jmeter-server kick shell
cd /usr/local/jmeter/bin
cat <<'EOF' > jmeter-server.sh
#!/bin/sh
CWD=`dirname $0`

# Get current ip address
IPADDRESS=`ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1`

# Execute jmeter-server with current ip address
${CWD}/jmeter -Djava.rmi.server.hostname=${IPADDRESS} -s -j jmeter-server.log "$@"
EOF
chmod +x jmeter-server.sh

# Add service file
cd /tmp
cat <<EOF > jmeter-server.service
[Unit]
Description = JMeter Server Daemon

[Service]
ExecStart = /usr/local/jmeter/bin/jmeter-server.sh
Restart = always
Type = simple

[Install]
WantedBy = multi-user.target
EOF
mv ./jmeter-server.service /etc/systemd/system/jmeter-server.service

# Reload and set service
systemctl daemon-reload
systemctl enable jmeter-server
systemctl start jmeter-server

# Stop firewall
systemctl disable firewalld
systemctl stop firewalld