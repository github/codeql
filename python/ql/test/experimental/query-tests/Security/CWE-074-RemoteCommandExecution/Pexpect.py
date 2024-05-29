#!/usr/bin/env python

from fastapi import FastAPI
from pexpect import pxssh

ssh = pxssh.pxssh()
hostname = "localhost"
username = "username"
password = "password"
ssh.login(hostname, username, password)

app = FastAPI()

@app.get("/bad1")
async def bad1(cmd: str):
    ssh.send(cmd)  # $ result=BAD getRemoteCommand=cmd
    ssh.prompt()
    ssh.sendline(cmd)  # $ result=BAD getRemoteCommand=cmd
    ssh.prompt()
    ssh.logout()
    return {"success": stdout}