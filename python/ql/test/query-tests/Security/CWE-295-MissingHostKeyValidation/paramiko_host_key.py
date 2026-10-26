from paramiko.client import AutoAddPolicy, WarningPolicy, RejectPolicy, SSHClient

client = SSHClient()

client.set_missing_host_key_policy(AutoAddPolicy) # $ Alert # bad
client.set_missing_host_key_policy(RejectPolicy)  # good
client.set_missing_host_key_policy(WarningPolicy) # $ Alert # bad

# Using instances

client.set_missing_host_key_policy(AutoAddPolicy()) # $ Alert # bad
client.set_missing_host_key_policy(RejectPolicy())  # good
client.set_missing_host_key_policy(WarningPolicy()) # $ Alert # bad

# different import

import paramiko

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy) # $ Alert # bad
