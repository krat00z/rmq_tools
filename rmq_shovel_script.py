#!/usr/bin/env python3
import paramiko
import time
from time import sleep
host = raw_input("Enter hostname: ")
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname= host, username='')

stdin, stdout, stderr = ssh.exec_command("for i in $(rabbitmqctl list_vhosts | grep ''); do ech$
for line in stdout.read().splitlines():
    print(line)

stdin, stdout, stderr = ssh.exec_command("rabbitmq-plugins enable rabbitmq_shovel && rabbitmq-plugin$
for line in stdout.read().splitlines():
    print(line)
print ("Doing shovel")
time.sleep(2)

stdin, stdout, stderr = ssh.exec_command("for i in $(rabbitmqctl list_vhosts | grep ''); do ech$
for line in stdout.read().splitlines():
    print(line)

stdin, stdout, stderr = ssh.exec_command("rabbitmq-plugins disable rabbitmq_shovel")
for line in stdout.read().splitlines():
    print(line)
print ("Done, bye")
time.sleep(2)
ssh.close()
