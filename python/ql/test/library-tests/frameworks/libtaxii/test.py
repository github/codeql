from libtaxii.common import parse

result = parse("url", allow_url=True) # $ clientRequestUrlPart="url"
result = parse(s="url", allow_url=True) # $ clientRequestUrlPart="url"