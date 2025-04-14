#!/usr/bin/env python

from fastapi import FastAPI
import asyncssh


app = FastAPI()
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(("host", "port"))
session = Session()
session.handshake(sock)
session.userauth_password("user", "password")

@app.get("/bad1")
async def bad1(cmd: str):
    async with asyncssh.connect('localhost') as conn:
        result = await conn.run(cmd, check=True) # $ result=BAD getRemoteCommand=cmd
        print(result.stdout, end='')
    return {"success": "Dangerous"}
