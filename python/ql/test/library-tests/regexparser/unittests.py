import re

# Treatment of escapes
re.compile(r"X([^\.]|\.)*$") # No ReDoS.
re.compile(r"X(Æ|\Æ)+$") # Has ReDoS.

# Treatment of line breaks
re.compile(r'(?:.|\n)*b') # No ReDoS.
re.compile(r'(?:.|\n)*b', re.DOTALL) # Has ReDoS.

# minimal example constructed by @erik-krogh
baz = re.compile(r'\+0')

# exerpts from LGTM.com
re.compile(r'\+0x')
re.compile(r'\+0x.*')
re.compile(r'+\-0+\.')
re.compile('\s+\+0x[0-9]+')
re.compile(r'\+0000 .*')
re.compile('\#[0-9]+ 0x[0-9]')
