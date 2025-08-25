import re
#            0123456789ABCDEF
re.compile(r'012345678')
re.compile(r'(\033|~{)')
re.compile(r'\A[+-]?\d+')
re.compile(r'(?P<name>[\w]+)|')
re.compile(r'\|\[\][123]|\{\}')
re.compile(r'^.$')
re.compile(r'[^A-Z]')
#       0123456789ABCDEF
re.sub('(?m)^(?!$)', indent*' ', s)
re.compile("(?:(?:\n\r?)|^)( *)\S")
re.compile("[]]")
re.compile("[^]]")
re.compile("[^-]")

#Lookbehind group
re.compile(r'x|(?<!\w)l')
#braces, not qualifier
re.compile(r"x{Not qual}")

#Multiple carets and dollars
re.compile("^(^y|^z)(u$|v$)$")

#Multiples
re.compile("ax{3}")
re.compile("ax{,3}")
re.compile("ax{3,}")
re.compile("ax{01,3}")

#Negative lookahead
re.compile(r'(?!not-this)^[A-Z_]+$')
#Negative lookbehind
re.compile(r'^[A-Z_]+$(?<!not-this)')


#OK -- ODASA-ODASA-3968
re.compile('(?:[^%]|^)?%\((\w*)\)[a-z]')

#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]')
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]')

#Modes
re.compile("", re.VERBOSE)
re.compile("", flags=re.VERBOSE)
re.compile("", re.VERBOSE|re.DOTALL)
re.compile("", flags=re.VERBOSE|re.IGNORECASE)
re.search("", None, re.UNICODE)
x = re.search("", flags=re.UNICODE)
# using addition for flags was reported as FP in https://github.com/github/codeql/issues/4707
re.compile("", re.VERBOSE+re.DOTALL)
# re.X is an alias for re.VERBOSE
re.compile("", re.X)

#Inline flags; 'a', 'L' and 'u' are mutually exclusive
re.compile("(?aimsx)a+")
re.compile("(?ui)a+")
re.compile(b"(?Li)a+")
#Group with inline flags; TODO: these are not properly parsed and handled yet
re.compile("(?aimsx:a+)")
re.compile("(?-imsx:a+)")
re.compile("(?a-imsx:a+)")

#empty choice
re.compile(r'|x')
re.compile(r'x|')

#Named group with caret and empty choice.
re.compile(r'(?:(?P<n1>^(?:|x)))')

#Misparsed
re.compile(r"\[(?P<txt>[^[]*)\]\((?P<uri>[^)]*)")

re.compile("", re.M) # ODASA-8056

# FP reported in https://github.com/github/codeql/issues/3712
# This does not define a regex (but could be used by other code to do so)
escaped = re.escape("https://www.humblebundle.com/home/library")

# Consistency check
baz = re.compile(r'\+0')

# Anchors
re.compile(r'\Afoo\Z')
re.compile(r'\bfoo\B')