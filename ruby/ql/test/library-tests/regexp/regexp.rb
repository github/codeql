# Empty
//

# Basic sequence
/abc/

# Repetition
/a*b+c?d/
/a{4,8}/
/a{,8}/
/a{3,}/
/a{7}/

# Alternation
/foo|bar/

# Character classes
/[abc]/
/[a-fA-F0-9_]/
/\A[+-]?\d+/
/[\w]+/
/\[\][123]/
/[^A-Z]/
/[]]/  # MRI gives a warning, but accepts this as matching ']'
/[^]]/ # MRI gives a warning, but accepts this as matching anything except ']'
/[^-]/
/[|]/

# Nested character classes
/[[a-f]A-F]/ # BAD - not parsed correctly

# Meta-character classes
/.*/
/.*/m
/\w+\W/
/\s\S/
/\d\D/
/\h\H/
/\n\r\t/

# Anchors
/\Gabc/
/\b!a\B/

# Groups
/(foo)*bar/
/fo(o|b)ar/
/(a|b|cd)e/
/(?::+)\w/ # Non-capturing group matching colons

# Named groups
/(?<id>\w+)/
/(?'foo'fo+)/

# Backreferences
/(a+)b+\1/
/(?<qux>q+)\s+\k<qux>+/

# Named character properties using the p-style syntax
/\p{Word}*/
/\P{Digit}+/
/\p{^Alnum}{2,3}/
/[a-f\p{Digit}]+/ # Also valid inside character classes

# Two separate character classes, each containing a single POSIX bracket expression
/[[:alpha:]][[:digit:]]/

# A single character class containing two POSIX bracket expressions
/[[:alpha:][:digit:]]/

# A single character class containing two ranges and one POSIX bracket expression
/[A-F[:digit:]a-f]/

# *Not* a POSIX bracket expression; just a regular character class.
/[:digit:]/

# Simple constant interpolation
A = "a"
/#{A}bc/

# unicode
/\u{9879}/