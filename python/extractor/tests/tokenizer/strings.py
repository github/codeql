

#Raw

r'012345678'
r'(\033|~{)'
r'\A[+-]?\d+'
r'(?P<name>[\w]+)|'
r'\|\[\][123]|\{\}'
r'^.$'
r'[^A-Z]'

# With escapes

'\n'
"\'"
'\''
"\""
"\t\l\b"


#F-strings

f''
rf'hello'
fr'hello'
f'a{1+1}b'
f'{x}{y}a{z}'
#This is not legal in CPython, but we tokenize it anyway.
f'a{'x'+"y"}b'

#Multiline f-string
f'''
    In f-string expressions act as if parenthesised
{
    x +
    y &
      z
}
end
'''

#Multi-line


r""" Single quotation character with multi-line

"a", 'b', "", ''
....
"""

r''' Single quotation character with multi-line

"a", 'b', "", ''
....
'''

#f-string conversions
!a
!s
!r

f"{k}={v!r}"

#Implicit concatenation
(f'{expr} text '
    'continuation'
    f'and{v}'
)

#prefixes

u'{}\r{}{:<{width}}'
u'{}\r{}{:<{}}'

#f-strings with format specifier
f'result: {value:0.2f}'
f'result: {value:{width}.{precision}}'


f"Too {'many' if alen > elen else 'few'} parameters for {cls};"

# f-strings have special escaping rules for curly-brackets
f'This should work \{foo}'
rf'This should work \{foo}'

f'\}' # syntax error (we currently don't report this)
f'\}}' # ok


# f-strings with unicode literals of the form `\N{...}`
f'{degrees:0.0f}\N{DEGREE SIGN}'
f"{degrees:0.0f}\N{DEGREE SIGN}"
f'''{degrees:0.0f}\N{DEGREE SIGN}'''
f"""{degrees:0.0f}\N{DEGREE SIGN}"""

# double curlies in f-strings with various kinds of quoting
f'{{ {foo} }}'
f"{{ {foo} }}"
f'''{{ {foo} }}'''
f"""{{ {foo} }}"""

# Empty f-strings
f''
f""
f''''''
f""""""


r'\NUL' # _Not_ a named unicode escape (`\N{...}`)

f'res: {val:{width:0}.{prec:1}}'
