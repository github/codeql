import aiohttp
import asyncio

s = aiohttp.ClientSession()
resp = s.request("method", "url") # $ clientRequestUrlPart="url"
resp = s.request("method", url="url") # $ clientRequestUrlPart="url"

with aiohttp.ClientSession() as session:
    resp = session.get("url") # $ clientRequestUrlPart="url"
    resp = session.request(method="GET", url="url") # $ clientRequestUrlPart="url"

# other methods than GET
s = aiohttp.ClientSession()
resp = s.post("url") # $ clientRequestUrlPart="url"
resp = s.patch("url") # $ clientRequestUrlPart="url"
resp = s.options("url") # $ clientRequestUrlPart="url"