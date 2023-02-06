import ssl
from urllib.request import Request, urlopen

Request("url") # $ clientRequestUrlPart="url"
Request(url="url") # $ clientRequestUrlPart="url"

urlopen("url") # $ clientRequestUrlPart="url"
urlopen(url="url") # $ clientRequestUrlPart="url"

# ==============================================================================
# Certificate validation disabled
# ==============================================================================

# A manually constructed SSLContext does not have safe defaults, so is effectively the
# same as turning off SSL validation
context = ssl.SSLContext()
assert context.check_hostname == False
assert context.verify_mode == ssl.VerifyMode.CERT_NONE

urlopen("url", context=context) # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled
