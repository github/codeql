#!/usr/bin/env python

import paramiko
from paramiko import SSHClient
paramiko_ssh_client = SSHClient()
paramiko_ssh_client.load_system_host_keys()
paramiko_ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
paramiko_ssh_client.connect(hostname="127.0.0.1", port="22", username="ssh_user_name", pkey="k", timeout=11, banner_timeout=200)

cmd = "cmd"
paramiko_ssh_client.connect('hostname', username='user', password='yourpassword', sock=paramiko.ProxyCommand(cmd)) # $getCommand=cmd
