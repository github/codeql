from paramiko.client import AutoAddPolicy, WarningPolicy, RejectPolicy, SSHClient

client = SSHClient()

client.set_missing_host_key_policy(AutoAddPolicy) # bad
client.set_missing_host_key_policy(RejectPolicy)  # good
client.set_missing_host_key_policy(WarningPolicy) # bad

# Using instances

client.set_missing_host_key_policy(AutoAddPolicy()) # bad
client.set_missing_host_key_policy(RejectPolicy())  # good
client.set_missing_host_key_policy(WarningPolicy()) # bad
