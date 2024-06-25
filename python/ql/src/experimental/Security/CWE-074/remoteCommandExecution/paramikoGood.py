#!/usr/bin/env python

from flask import request, Flask
import paramiko
from paramiko import SSHClient

app = Flask(__name__)
paramiko_ssh_client = SSHClient()
paramiko_ssh_client.load_system_host_keys()
paramiko_ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
paramiko_ssh_client.connect(hostname="127.0.0.1", port="22", username="ssh_user_name", pkey="k", timeout=11, banner_timeout=200)


@app.route('/external_exec_command_1')
def withAuthorization():
    user_cmd = request.args.get('command')
    auth_jwt = request.args.get('Auth')
    # validating jwt token first
    # .... then continue to run the command
    stdin, stdout, stderr = paramiko_ssh_client.exec_command(user_cmd)
    return stdout


if __name__ == '__main__':
    app.debug = False
    app.run()

