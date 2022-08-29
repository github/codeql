import aiohttp
import asyncio
import ssl

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

# disabling of SSL validation
# see https://docs.aiohttp.org/en/stable/client_reference.html#aiohttp.ClientSession.request
s.get("url", ssl=False) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
s.get("url", ssl=0) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
# None is treated as default and so does _not_ disable the check
s.get("url", ssl=None) # $ clientRequestUrlPart="url"

# deprecated since 3.0, but still supported
s.get("url", verify_ssl=False) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

# A manually constructed SSLContext does not have safe defaults, so is effectively the
# same as turning off SSL validation
context = ssl.SSLContext()
assert context.check_hostname == False
assert context.verify_mode == ssl.VerifyMode.CERT_NONE

s.get("url", ssl=context) # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled
