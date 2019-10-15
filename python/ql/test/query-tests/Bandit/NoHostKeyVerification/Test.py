from paramiko import client

ssh_client = client.SSHClient()
ssh_client.set_missing_host_key_policy(client.AutoAddPolicy)
ssh_client.set_missing_host_key_policy(client.WarningPolicy)
