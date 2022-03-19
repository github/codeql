from urllib.request import Request, urlopen

Request("url") # $ clientRequestUrlPart="url"
Request(url="url") # $ clientRequestUrlPart="url"

urlopen("url") # $ clientRequestUrlPart="url"
urlopen(url="url") # $ clientRequestUrlPart="url"