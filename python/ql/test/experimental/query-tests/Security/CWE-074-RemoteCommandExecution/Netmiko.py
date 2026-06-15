#!/usr/bin/env python

from fastapi import FastAPI
from netmiko import ConnectHandler


app = FastAPI()
cisco_881 = {
    'device_type': 'cisco_ios',
    'host': '10.10.10.10',
    'username': 'test',
    'password': 'password',
    'port': 8022,  # optional, defaults to 22
    'secret': 'secret',  # optional, defaults to ''
}

@app.get("/bad1")
async def bad1(cmd: str):  # $ Source
    net_connect = ConnectHandler(**cisco_881)
    net_connect.send_command(command_string=cmd) # $ Alert result=BAD getRemoteCommand=cmd
    net_connect.send_command_expect(command_string=cmd) # $ Alert result=BAD getRemoteCommand=cmd
    net_connect.send_command_timing(command_string=cmd) # $ Alert result=BAD getRemoteCommand=cmd
    net_connect.send_multiline(commands=[[cmd, "expect"]]) # $ Alert result=BAD getRemoteCommand=List
    net_connect.send_multiline_timing(commands=cmd) # $ Alert result=BAD getRemoteCommand=cmd
    return {"success": "Dangerous"}
