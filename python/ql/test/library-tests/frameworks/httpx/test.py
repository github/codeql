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

client = httpx.AsyncClient()
response = client.get("url") # $ clientRequestUrlPart="url"
response = client.post("url") # $ clientRequestUrlPart="url"
response = client.patch("url") # $ clientRequestUrlPart="url"
response = client.options("url") # $ clientRequestUrlPart="url"
response = client.request("method", url="url") # $ clientRequestUrlPart="url"
response = client.stream("method", url="url") # $ clientRequestUrlPart="url"
