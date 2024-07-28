import re

# Treatment of escapes
re.compile(r"X([^\.]|\.)*$") # No ReDoS.
re.compile(r"X(Æ|\Æ)+$") # Has ReDoS.

# Treatment of line breaks
re.compile(r'(?:.|\n)*b') # No ReDoS.
re.compile(r'(?:.|\n)*b', re.DOTALL) # Has ReDoS.
re.compile(r'(?i)(?:.|\n)*b') # No ReDoS.
re.compile(r'(?s)(?:.|\n)*b') # Has ReDoS.
re.compile(r'(?is)(?:.|\n)*b') # Has ReDoS.
re.compile(r'(?is)X(?:.|\n)*Y') # Has ReDoS.
