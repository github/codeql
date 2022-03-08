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
