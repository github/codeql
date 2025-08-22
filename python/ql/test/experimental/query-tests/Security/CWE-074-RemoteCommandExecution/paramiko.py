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
async def bad1(cmd: str):
    stdin, stdout, stderr = paramiko_ssh_client.exec_command(cmd)  # $ result=BAD getRemoteCommand=cmd
    return {"success": "Dangerous"}

@app.get("/bad2")
async def bad2(cmd: str):
    stdin, stdout, stderr = paramiko_ssh_client.exec_command(command=cmd)  # $ result=BAD getRemoteCommand=cmd
    return {"success": "Dangerous"}
