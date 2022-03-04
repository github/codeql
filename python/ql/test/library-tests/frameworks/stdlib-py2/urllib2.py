import urllib2

resp = urllib2.Request("url") # $ clientRequestUrlPart="url"
resp = urllib2.Request(url="url") # $ clientRequestUrlPart="url"

resp = urllib2.urlopen("url") # $ clientRequestUrlPart="url"
resp = urllib2.urlopen(url="url") # $ clientRequestUrlPart="url"