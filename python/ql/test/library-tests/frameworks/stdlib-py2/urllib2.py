import urllib2
import ssl

resp = urllib2.Request("url") # $ clientRequestUrlPart="url"
resp = urllib2.Request(url="url") # $ clientRequestUrlPart="url"

resp = urllib2.urlopen("url") # $ clientRequestUrlPart="url"
resp = urllib2.urlopen(url="url") # $ clientRequestUrlPart="url"

# ==============================================================================
# Certificate validation disabled
# ==============================================================================

# A manually constructed SSLContext does not have safe defaults, so is effectively the
# same as turning off SSL validation
context = ssl.SSLContext()
assert context.check_hostname == False
assert context.verify_mode == ssl.VerifyMode.CERT_NONE

urllib2.urlopen("url", context=context) # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled
