import httpx

httpx.get("url") # $ clientRequestUrlPart="url"
httpx.post("url") # $ clientRequestUrlPart="url"
httpx.patch("url") # $ clientRequestUrlPart="url"
httpx.options("url") # $ clientRequestUrlPart="url"
httpx.request("method", url="url") # $ clientRequestUrlPart="url"
httpx.stream("method", url="url") # $ clientRequestUrlPart="url"

client = httpx.Client()
response = client.get("url") # $ clientRequestUrlPart="url"
response = client.post("url") # $ clientRequestUrlPart="url"
response = client.patch("url") # $ clientRequestUrlPart="url"
response = client.options("url") # $ clientRequestUrlPart="url"
response = client.request("method", url="url") # $ clientRequestUrlPart="url"
response = client.stream("method", url="url") # $ clientRequestUrlPart="url"

async def async_test():
    client = httpx.AsyncClient()
    response = await client.get("url") # $ clientRequestUrlPart="url"
    response = await client.post("url") # $ clientRequestUrlPart="url"
    response = await client.patch("url") # $ clientRequestUrlPart="url"
    response = await client.options("url") # $ clientRequestUrlPart="url"
    response = await client.request("method", url="url") # $ clientRequestUrlPart="url"
    response = await client.stream("method", url="url") # $ clientRequestUrlPart="url"
