from paramiko.client import SSHClient, AutoAddPolicy, RejectPolicy

def unsafe_connect():
    client = SSHClient()
    client.set_missing_host_key_policy(AutoAddPolicy)
    client.connect("example.com")

    # ... interaction with server

    client.close()

def safe_connect():
    client = SSHClient()
    client.set_missing_host_key_policy(RejectPolicy)
    client.connect("example.com")

    # ... interaction with server

    client.close()
