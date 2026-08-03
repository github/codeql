import re

# Treatment of escapes
re.compile(r"X([^\.]|\.)*$") # No ReDoS.
re.compile(r"X(Æ|\Æ)+$") # $ Alert # Has ReDoS.

# Treatment of line breaks
re.compile(r'(?:.|\n)*b') # No ReDoS.
re.compile(r'(?:.|\n)*b', re.DOTALL) # $ Alert # Has ReDoS.
re.compile(r'(?i)(?:.|\n)*b') # No ReDoS.
re.compile(r'(?s)(?:.|\n)*b') # $ Alert # Has ReDoS.
re.compile(r'(?is)(?:.|\n)*b') # $ Alert # Has ReDoS.
re.compile(r'(?is)X(?:.|\n)*Y') # $ Alert # Has ReDoS.
