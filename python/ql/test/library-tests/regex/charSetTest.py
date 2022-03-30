import re
re.compile(r'\A[+-]?\d+') #$ charSet=2:6
re.compile(r'(?P<name>[\w]+)|') #$ charSet=9:13
re.compile(r'\|\[\][123]|\{\}') #$ charSet=6:11
re.compile(r'[^A-Z]') #$ charSet=0:6
re.compile("[]]") #$ charSet=0:3
re.compile("[][]") #$ charSet=0:4
re.compile("[^][^]") #$ charSet=0:6
re.compile("[.][.]") #$ charSet=0:3 charSet=3:6
re.compile("[[]]") #$ charSet=0:3
re.compile("[^]]") #$ charSet=0:4
re.compile("[^-]") #$ charSet=0:4

try:
    re.compile("[]-[]") #$ SPURIOUS: charSet=0:5
    raise Exception("this should not be reached")
except re.error:
    pass

try:
    re.compile("[^]-[]") #$ SPURIOUS: charSet=0:6
    raise Exception("this should not be reached")
except re.error:
    pass

re.compile("]]][[[[]") #$ charSet=3:8


#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]') #$ charSet=0:5 charSet=5:10
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]') #$ charSet=0:5

#Misparsed on LGTM
re.compile(r"\[(?P<txt>[^[]*)\]\((?P<uri>[^)]*)") #$ charSet=10:14 charSet=28:32

 # parses wrongly, sees this   \|/ as a char set start
re.compile(r'''(?:[\s;,"'<>(){}|[\]@=+*]|:(?![/\\]))+''') #$ charSet=3:25 charSet=30:35
