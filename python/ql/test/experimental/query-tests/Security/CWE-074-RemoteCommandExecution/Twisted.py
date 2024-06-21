#!/usr/bin/env python

from fastapi import FastAPI
from twisted.conch.endpoints import SSHCommandClientEndpoint
from twisted.internet.protocol import Factory
from twisted.internet import reactor


app = FastAPI()


@app.get("/bad1")
async def bad1(cmd: bytes):
    endpoint = SSHCommandClientEndpoint.newConnection(
    reactor,
    cmd, # $ result=BAD getRemoteCommand=cmd  
    b"username",
    b"ssh.example.com",
    22,
    password=b"password") 

    SSHCommandClientEndpoint.existingConnection(
        endpoint,
        cmd) # $ result=BAD getRemoteCommand=cmd
    
    factory = Factory()
    d = endpoint.connect(factory)
    d.addCallback(lambda protocol: protocol.finished)

    return {"success": "Dangerous"}
