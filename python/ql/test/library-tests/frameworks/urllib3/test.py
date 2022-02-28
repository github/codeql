import urllib3

http = urllib3.PoolManager()

resp = http.request("method", "url") # $ clientRequestUrlPart="url"
resp = http.request("method", url="url") # $ clientRequestUrlPart="url"
resp = http.urlopen("method", "url") # $ clientRequestUrlPart="url"
resp = http.urlopen("method", url="url") # $ clientRequestUrlPart="url"