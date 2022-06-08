import httpx
import ssl

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

# ==============================================================================
# Disabling certificate validation
# ==============================================================================

httpx.get("url", verify=False) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
httpx.get("url", verify=0) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
httpx.get("url", verify=None) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

# A manually constructed SSLContext does not have safe defaults, so is effectively the
# same as turning off SSL validation
context = ssl.SSLContext()
assert context.check_hostname == False
assert context.verify_mode == ssl.VerifyMode.CERT_NONE

httpx.get("url", verify=context) # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled

client = httpx.Client(verify=False)
client.get("url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
