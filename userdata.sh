#!/usr/bin/env bash

# Update and Grab Node + Git + awslogs
yum update -y
curl -sL https://rpm.nodesource.com/setup_10.x | bash -
yum install -y nodejs git awslogs

# Configure CloudWatch Logs and AWS CLI
cat >/etc/awslogs/awscli.conf <<-EOF
[default]
region = ${aws_region}

[plugins]
cwlogs = cwlogs
EOF

# Set up the various CloudWatch Log Groups and Streams
cat >/etc/awslogs/awslogs.conf <<-EOF
[general]
state_file = /var/lib/awslogs/agent-state

# Global Messages
[/var/log/messages]
file = /var/log/messages
log_group_name = ${log_group_name}
log_stream_name = /var/log/messages
datetime_format = %b %d %H:%M:%S

# SSH logs
[/var/log/secure]
file = /var/log/secure
log_group_name = ${log_group_name}
log_stream_name = /var/log/secure
datetime_format = %b %d %H:%M:%S

# Cloud Init Logs (results of User Data Scripts)
[/var/log/cloud-init.log]
file = /var/log/cloud-init.log
log_group_name = ${log_group_name}
log_stream_name = /var/log/cloud-init.log
datetime_format = %b %d %H:%M:%S

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log
log_group_name = ${log_group_name}
log_stream_name = /var/log/cloud-init-output.log
datetime_format = %b %d %H:%M:%S

# Nodejs Messages
[/var/log/nodejs.log]
file = /var/log/nodejs.log
log_group_name = ${log_group_name}
log_stream_name = /var/log/nodejs.log
datetime_format = %b %d %H:%M:%S

# Nodejs Error Messages
[/var/log/nodejserr.log]
file = /var/log/nodejserr.log
log_group_name = ${log_group_name}
log_stream_name = /var/log/nodejserr.log
datetime_format = %b %d %H:%M:%S
EOF

# Create the Node Log File
cat >/var/log/nodejs.log <<-EOF
[Nodejs Logs]

EOF

# Create the Node Error Log File
cat >/var/log/nodejserr.log <<-EOF
[Nodejs Error Logs]

EOF

# Give non-root default user "ec2-user" permissions to write to the log files
chown ec2-user:ec2-user /var/log/nodejs.log /var/log/nodejserr.log
chmod 644 /var/log/nodejs.log /var/log/nodejserr.log

# Start AWS Logs and Ensure Running
systemctl start awslogsd
systemctl enable awslogsd.service

# Make a directory to clone the application code to
mkdir -p /home/ec2-user/app && cd /home/ec2-user/app

# Clone the Git Repo
git clone https://github.com/jcolemorrison/ec2-lb-api.git .

# Install Dependencies
npm install

# Redirect Port 3000 to Port 80 Traffic
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

# Run Node as the ec2-user
su ec2-user -c "node . > /var/log/nodejs.log 2> /var/log/nodejserr.log"
