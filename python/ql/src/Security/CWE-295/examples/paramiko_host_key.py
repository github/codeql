from paramiko.client import SSHClient, AutoAddPolicy

client = SSHClient()
client.set_missing_host_key_policy(AutoAddPolicy)
client.connect("example.com")

# ... interaction with server

client.close()
