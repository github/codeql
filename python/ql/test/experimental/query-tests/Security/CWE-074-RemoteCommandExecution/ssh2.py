#!/usr/bin/env python

from fastapi import FastAPI
from socket import socket
from ssh2.session import Session

app = FastAPI()
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("host", "port"))
session = Session()
session.handshake(sock)
session.userauth_password("user", "password")

@app.get("/bad1")
async def bad1(cmd: str):
    channel = session.open_session()
    channel.execute(cmd) # $ result=BAD getRemoteCommand=cmd
    channel.wait_eof()
    channel.close()
    channel.wait_closed()  
    return {"success": "Dangerous"}
