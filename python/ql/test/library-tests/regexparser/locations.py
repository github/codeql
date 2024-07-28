import re

# This file contains tests for the regexp parser's location tracking.

# To keep the expected results manageable, we only test the locations of the
# regexp term `[this]`, appearing in various kinds of regexps.
#
# To make the location information easier to understand, we generally put each
# regexp on its own line, even though this is not idiomatic Python.
# Comments indicate the found locations relative to the call to `compile`.

# plain string
re.compile( # $location=1:2
'[this] is a test'
)

# raw string
re.compile( # $ location=1:3
r'[this] is a test'
)

# byte string
re.compile( # $ location=1:3
b'[this] is a test'
)

# byte raw string
re.compile( # $ location=1:4
br'[this] is a test'
)

# multiline string
re.compile( # $ location=1:4
'''[this] is a test'''
)

# multiline raw string
re.compile( # $ location=1:5
r'''[this] is a test'''
)

# multiline byte string
re.compile( # $ location=1:5
b'''[this] is a test'''
)

# multiline byte raw string
re.compile( # $ location=1:6
br'''[this] is a test'''
)

# plain string with multiple parts
re.compile( # $ location=1:2 location=1:26
'[this] is a test' ' and [this] is another test'
)

# plain string with multiple parts across lines
re.compile( # $ location=1:2 location=2:7 location=3:2
'[this] is a test'
' and [this] is another test'
'[this] comes right at the start of a part'
)

# plain string with multiple parts across lines and comments
re.compile( # $ location=1:2 location=3:7
'[this] is a test'
# comment
' and [this] is another test'
)

# multiple parts of different kinds
re.compile( # $ location=1:2 location=1:28 location=2:11 location=3:8
'[this] is a test' ''' and [this] is another test'''
br""" and [this] is yet another test"""
r' and [this] is one more'
)

# actual multiline string
re.compile( # $ SPURIOUS:location=1:6 location=1:27 MISSING:location=2:1 location=3:5
r'''
[this] is a test
and [this] is another test
'''
)

# plain string with escape sequences
re.compile( # $ SPURIOUS:location=1:3 MISSING:location=1:4
'\t[this] is a test'
)

# raw string with escape sequences
re.compile( # $ location=1:5
r'\A[this] is a test'
)

# plain string with escaped newline
re.compile( # $ location=1:2 SPURIOUS:location=1:23 MISSING:location=2:6
'[this] is a test\
 and [this] is another test'
)