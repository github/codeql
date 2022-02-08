import requests

resp = requests.get("url") # $ clientRequestUrlPart="url"
resp = requests.get(url="url") # $ clientRequestUrlPart="url"

resp = requests.request("GET", "url") # $ clientRequestUrlPart="url"

with requests.Session() as session:
    resp = session.get("url") # $ clientRequestUrlPart="url"
    resp = session.request(method="GET", url="url") # $ clientRequestUrlPart="url"

s = requests.Session()
resp = s.get("url") # $ clientRequestUrlPart="url"

s = requests.session()
resp = s.get("url") # $ clientRequestUrlPart="url"

# test full import path for Session
with requests.sessions.Session() as session:
    resp = session.get("url") # $ clientRequestUrlPart="url"

# Low level access
req = requests.Request("GET", "url") # $ MISSING: clientRequestUrlPart="url"
resp = s.send(req.prepare())

# other methods than GET
resp = requests.post("url") # $ clientRequestUrlPart="url"
resp = requests.patch("url") # $ clientRequestUrlPart="url"
resp = requests.options("url") # $ clientRequestUrlPart="url"

# ==============================================================================
# Disabling certificate validation
# ==============================================================================

resp = requests.get("url", verify=False) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

def make_get(verify_arg):
    resp = requests.get("url", verify=verify_arg) # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

make_get(False)


with requests.Session() as session:
    # see https://github.com/psf/requests/blob/39d0fdd9096f7dceccbc8f82e1eda7dd64717a8e/requests/sessions.py#L621
    session.verify = False
    resp = session.get("url") # $ clientRequestUrlPart="url" MISSING: clientRequestCertValidationDisabled
    resp = session.get("url", verify=True) # $ clientRequestUrlPart="url"

    req = requests.Request("GET", "url") # $ MISSING: clientRequestUrlPart="url"
    resp = session.send(req.prepare()) # $ MISSING: clientRequestCertValidationDisabled
