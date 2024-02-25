#!/usr/bin/env python

from fastapi import FastAPI
from scrapli import Scrapli
from scrapli.driver.core import AsyncNXOSDriver, AsyncJunosDriver, AsyncEOSDriver, AsyncIOSXEDriver, AsyncIOSXRDriver
from scrapli.driver.core import NXOSDriver, JunosDriver, EOSDriver, IOSXEDriver, IOSXRDriver
from scrapli.driver import GenericDriver


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
async def bad1(cmd: str):
    dev_connect = {
        "host": host,
        "auth_username": user,
        "auth_password": password,
        "port": port,
        "auth_strict_key": False,
        "transport": "asyncssh",
    }
    driver = AsyncIOSXEDriver
    async with driver(**dev_connect) as conn:
        output = await conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = AsyncIOSXRDriver
    async with driver(**dev_connect) as conn:
        output = await conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = AsyncNXOSDriver
    async with driver(**dev_connect) as conn:
        output = await conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = AsyncEOSDriver
    async with driver(**dev_connect) as conn:
        output = await conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = AsyncJunosDriver
    async with driver(**dev_connect) as conn:
        output = await conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    return {"success": "Dangerous"}

@app.get("/bad1")
def bad2(cmd: str):
    dev_connect = {
        "host": host,
        "auth_username": user,
        "auth_password": password,
        "port": port,
        "auth_strict_key": False,
        "transport": "ssh2",
    }
    driver = NXOSDriver
    with driver(**dev_connect) as conn:
        output = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = IOSXRDriver
    with driver(**dev_connect) as conn:
        output = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = IOSXEDriver
    with driver(**dev_connect) as conn:
        output = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = EOSDriver
    with driver(**dev_connect) as conn:
        output = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    driver = JunosDriver
    with driver(**dev_connect) as conn:
        output = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd

    dev_connect = {
        "host": "65.65.65.65",
        "auth_username": "root",
        "auth_private_key": "keyPath",
        "auth_strict_key": False,
        "transport": "ssh2",
        "platform": "cisco_iosxe",
    }
    with Scrapli(**dev_connect) as conn:
        result = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd

    dev_connect = {
        "host": "65.65.65.65",
        "auth_username": "root",
        "auth_password": "password",
        "auth_strict_key": False,
        "transport": "ssh2",
    }
    with GenericDriver(**dev_connect) as conn:
        result = conn.send_command(cmd) # $ result=BAD getSecondaryCommand=cmd
    return {"success": "Dangerous"}
