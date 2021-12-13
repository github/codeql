import requests

resp = requests.get("url") # $ clientRequestUrl="url"
resp = requests.get(url="url") # $ clientRequestUrl="url"

resp = requests.request("GET", "url") # $ clientRequestUrl="url"

with requests.Session() as session:
    resp = session.get("url") # $ clientRequestUrl="url"
    resp = session.request(method="GET", url="url") # $ clientRequestUrl="url"

s = requests.Session()
resp = s.get("url") # $ clientRequestUrl="url"

s = requests.session()
resp = s.get("url") # $ clientRequestUrl="url"

# test full import path for Session
with requests.sessions.Session() as session:
    resp = session.get("url") # $ clientRequestUrl="url"

# Low level access
req = requests.Request("GET", "url") # $ MISSING: clientRequestUrl="url"
resp = s.send(req.prepare())

# other methods than GET
resp = requests.post("url") # $ clientRequestUrl="url"
resp = requests.patch("url") # $ clientRequestUrl="url"
resp = requests.options("url") # $ clientRequestUrl="url"

# ==============================================================================
# Disabling certificate validation
# ==============================================================================

resp = requests.get("url", verify=False) # $ clientRequestUrl="url" clientRequestCertValidationDisabled

def make_get(verify_arg):
    resp = requests.get("url", verify=verify_arg) # $ clientRequestUrl="url" clientRequestCertValidationDisabled

make_get(False)


with requests.Session() as session:
    # see https://github.com/psf/requests/blob/39d0fdd9096f7dceccbc8f82e1eda7dd64717a8e/requests/sessions.py#L621
    session.verify = False
    resp = session.get("url") # $ clientRequestUrl="url" MISSING: clientRequestCertValidationDisabled
    resp = session.get("url", verify=True) # $ clientRequestUrl="url"

    req = requests.Request("GET", "url") # $ MISSING: clientRequestUrl="url"
    resp = session.send(req.prepare()) # $ MISSING: clientRequestCertValidationDisabled
