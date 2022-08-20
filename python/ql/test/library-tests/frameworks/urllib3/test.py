import urllib3

pool = urllib3.PoolManager()

resp = pool.request("method", "url") # $ clientRequestUrlPart="url"
resp = pool.request("method", url="url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", "url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", url="url") # $ clientRequestUrlPart="url"

pool = urllib3.ProxyManager("http://proxy")

resp = pool.request("method", "url") # $ clientRequestUrlPart="url"
resp = pool.request("method", url="url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", "url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", url="url") # $ clientRequestUrlPart="url"

pool = urllib3.HTTPConnectionPool("host")

resp = pool.request("method", "url") # $ clientRequestUrlPart="url"
resp = pool.request("method", url="url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", "url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", url="url") # $ clientRequestUrlPart="url"

pool = urllib3.HTTPSConnectionPool("host")

resp = pool.request("method", "url") # $ clientRequestUrlPart="url"
resp = pool.request("method", url="url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", "url") # $ clientRequestUrlPart="url"
resp = pool.urlopen("method", url="url") # $ clientRequestUrlPart="url"

# ==============================================================================
# Certificate validation disabled
# ==============================================================================

# see https://docs.python.org/3.10/library/ssl.html#ssl.CERT_NONE
pool = urllib3.HTTPSConnectionPool("host", cert_reqs='CERT_NONE')
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

pool = urllib3.HTTPSConnectionPool("host", assert_hostname=False)
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

pool = urllib3.HTTPSConnectionPool("host", cert_reqs='CERT_NONE', assert_hostname=False)
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled


# same with PoolManager
pool = urllib3.PoolManager(cert_reqs='CERT_NONE')
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

pool = urllib3.PoolManager(assert_hostname=False)
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled


# and same with ProxyManager
pool = urllib3.ProxyManager("https://proxy", cert_reqs='CERT_NONE')
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled

pool = urllib3.ProxyManager("https://proxy", assert_hostname=False)
resp = pool.request("method", "url") # $ clientRequestUrlPart="url" clientRequestCertValidationDisabled
