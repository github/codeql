import re

# This file contains tests for the regexp parser's location tracking.

# To keep the expected results manageable, we only test the locations of the
# regexp term `[this]`, appearing in various kinds of regexps.
#
# To make the location information easier to understand, we generally put each
# regexp on its own line, even though this is not idiomatic Python.
# Comments indicate cases we currently do not handle correctly.

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

# plain string with multiple parts (second [this] gets wrong column: 23 instead of 26)
re.compile(
'[this] is a test' ' and [this] is another test'
)

# plain string with multiple parts across lines (second [this] gets wrong location: 59:23 instead of 60:7)
re.compile(
'[this] is a test'
' and [this] is another test'
)

# plain string with multiple parts across lines and comments (second [this] gets wrong location: 65:23 instead of 67:7)
re.compile(
'[this] is a test'
# comment
' and [this] is another test'
)

# actual multiline string (both [this]s get wrong location: 72:6 and 72:27 instead of 73:1 and 74:5)
re.compile(
r'''
[this] is a test
and [this] is another test
'''
)

# plain string with escape sequences ([this] gets wrong location: 80:3 instead of 80:4)
re.compile(
'\t[this] is a test'
)

# raw string with escape sequences
re.compile(
r'\A[this] is a test'
)

# plain string with escaped newline (second [this] gets wrong location: 90:23 instead of 91:6)
re.compile(
'[this] is a test\
 and [this] is another test'
)