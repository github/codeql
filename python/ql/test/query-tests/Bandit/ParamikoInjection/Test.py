import paramiko


client = paramiko.client.SSHClient()

# this is not safe
client.exec_command('something; really; unsafe')

# this is safe
client.connect('somehost')
