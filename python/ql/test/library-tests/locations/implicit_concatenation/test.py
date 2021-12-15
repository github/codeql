#Single line concat
"Hello "     "World"

#Multi line concat with line continuation
"Goodbye " \
"World"

#Single line concat in list
[ "a" "b" ]

#Single line, looks like tuple, but is just parenthesized
("c" "d" )

#Multi line in list
[
    'e'
    'f'
]

#Simple String
"string"

#String with escapes
"\n\n\n\n"

#String with unicode escapes
u'\u0123\u1234'

#These implicit concatenations can only be found with extractor support.

#Concat with empty String
'word' ''

#String with escapes and concatenation : 
'\n\n\n\n' '0'

