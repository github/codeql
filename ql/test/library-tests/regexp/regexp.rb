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

# Meta-character classes
/.*/
/.*/m
/\w+\W/
/\s\S/
/\d\D/
/\h\H/
/\n\r\t/

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

# Named character properties
/\p{Word}*/
/\P{Digit}+/
/\p{^Alnum}{2,3}/
/[[:alpha:]][[:digit:]]+/