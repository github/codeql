import re

# This file contains tests for the regexp parser's location tracking.

# To keep the expected results manageable, we only test the locations of the
# regexp term `[this]`, appearing in various kinds of regexps.
#
# To make the location information easier to understand, we generally put each
# regexp on its own line, even though this is not the way one would normally
# write regexps in Python.

# plain string
re.compile(
'[this] is a test'
)

# raw string
re.compile(
r'[this] is a test'
)

# byte string
re.compile(
b'[this] is a test'
)

# byte raw string
re.compile(
br'[this] is a test'
)

# multiline string
re.compile(
'''[this] is a test'''
)

# multiline raw string
re.compile(
r'''[this] is a test'''
)

# multiline byte string
re.compile(
b'''[this] is a test'''
)

# multiline byte raw string
re.compile(
br'''[this] is a test'''
)

# plain string with multiple parts
re.compile(
'[this] is a test' ' and [this] is another test'
)

# plain string with multiple parts across lines
re.compile(
'[this] is a test'
' and [this] is another test'
)

# plain string with multiple parts across lines and comments
re.compile(
'[this] is a test'
# comment
' and [this] is another test'
)

# actual multiline string
re.compile(
r'''
[this] is a test
and [this] is another test
'''
)

# plain string with escape sequences
re.compile(
'\t[this] is a test'
)

# raw string with escape sequences
re.compile(
r'\A[this] is a test'
)

# plain string with escaped newline
re.compile(
'[this] is a test\
 and [this] is another test'
)