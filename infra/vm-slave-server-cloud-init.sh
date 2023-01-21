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

# Add service file
cd /tmp
cat <<EOF > jmeter-server.service
[Unit]
Description = JMeter Server Daemon

[Service]
ExecStart = /usr/local/jmeter/bin/jmeter-server
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
