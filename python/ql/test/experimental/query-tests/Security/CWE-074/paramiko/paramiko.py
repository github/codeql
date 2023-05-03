#!/usr/bin/env python

from fastapi import FastAPI
import paramiko
from paramiko import SSHClient
paramiko_ssh_client = SSHClient()
paramiko_ssh_client.load_system_host_keys()
paramiko_ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
paramiko_ssh_client.connect(hostname="127.0.0.1", port="22", username="ssh_user_name", pkey="k", timeout=11, banner_timeout=200)

app = FastAPI()


@app.get("/bad1")
async def read_item(cmd: str):
    stdin, stdout, stderr = paramiko_ssh_client.exec_command(cmd)
    return {"success": stdout}

@app.get("/bad2")
async def read_item(cmd: str):
    stdin, stdout, stderr = paramiko_ssh_client.exec_command(command=cmd)
    return {"success": "OK"}

@app.get("/bad3")
async def read_item(cmd: str):
    stdin, stdout, stderr = paramiko_ssh_client.connect('hostname', username='user',password='yourpassword',sock=paramiko.ProxyCommand(cmd))
    return {"success": "OK"}
