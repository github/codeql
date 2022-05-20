import re

# Treatment of escapes
re.compile(r"X([^\.]|\.)*$") # No ReDoS.
re.compile(r"X(Æ|\Æ)+$") # Has ReDoS.

# Treatment of line breaks
re.compile(r'(?:.|\n)*b') # No ReDoS.
re.compile(r'(?:.|\n)*b', re.DOTALL) # Has ReDoS.
