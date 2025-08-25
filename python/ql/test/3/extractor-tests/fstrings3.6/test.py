
f'hello {world!s}'
f'1{one:#06x}2{two:format}3{three!s:++++}'
f'goodbye {cruel} world'
f'ascii{thing!a}'
f'{x!r}'

f'''My name is {name}, my age next year is 
{age+1}, my anniversary is 
{anniversary:%A, %B %d, %Y}.'''

#Implicit concatenation
"hello" f' {world!s}'

# Simplified version of FP reported in issue #1990
f"{1,1}{1,1}"

# Trailing comma for 1-element tuple:
f"{1,}{1,}"

# Parenthesized with newline after string.
# Simplified version of FP reported in issue #2453

(f"""0"""
)
(f"0"
)
(f'''0'''
)
(f'0'
)
(f"""{0}"""
)
(f"{0}"
)
(f'''{0}'''
)
(f'{0}'
)
("""0"""
)
("0"
)
('''0'''
)
('0'
)




# Unicode literals inside fstrings in initial position
f'\N{DEGREE SIGN}{degrees}'

# Unicode literals inside fstrings in non-initial position
f'{1}\N{DEGREE SIGN}'

# {{ in initial position
f'{{ a{1}c'

# {{ in non-initial position
f'a{1}{{c'



# Unicode literals inside fspecs in initial position
f'pre{1:\N{LATIN SMALL LETTER B}>0.0f}post'

# Unicode literals inside fspecs in initial position
f'pre{1:0\N{LATIN SMALL LETTER B}}post'



# }} in initial position
f'}} a{1}c'

# }} in non-initial position
f'a{1}}}c'

# Empty f-strings
f''
f""
f''''''
f""""""
