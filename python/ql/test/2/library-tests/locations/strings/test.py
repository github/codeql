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
'\u0123\u1234'

#Concat with empty String
'word' ''

#String with escapes and concatenation : 
'\n\n\n\n' '0'

#Multiline string
'''
line 0
line 1
'''

#Multiline impicitly concatenated string
'''
line 2
line 3
'''   '''
line 4
line 5
'''

#Implicitly concatenated 

