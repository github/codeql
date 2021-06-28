import re
re.compile(r'\A[+-]?\d+') #$ MISSING: charSet=2:6
re.compile(r'(?P<name>[\w]+)|') #$ MISSING: charSet=9:13
re.compile(r'\|\[\][123]|\{\}') #$ MISSING: charSet=6:11
re.compile(r'[^A-Z]') #$ MISSING: charSet=0:6
re.compile("[]]") #$ charSet=0:3
re.compile("[][]") #$ MISSING: charSet=0:4
re.compile("[^][^]") #$ MISSING: charSet=0:6
re.compile("[.][.]") #$ charSet=0:3 MISSING: charSet=3:6
re.compile("[[]]") #$ charSet=0:3
re.compile("[^]]") #$ MISSING: charSet=0:4
re.compile("[^-]") #$ MISSING: charSet=0:4
re.compile("[]-[]") #$ MISSING: charSet=0:5
re.compile("[^]-[]") #$ MISSING: charSet=0:6

re.compile("]]][[[[]") #$ MISSING: charSet=3:8


#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]') #$ MISSING: charSet=0:5 charSet=5:10
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]') #$ MISSING: charSet=0:5

#Misparsed on LGTM
re.compile(r"\[(?P<txt>[^[]*)\]\((?P<uri>[^)]*)") #$ MISSING: charSet=10:14 charSet=28:32

 # parses wrongly, sees this   \|/ as a char set start
re.compile(r'''(?:[\s;,"'<>(){}|[\]@=+*]|:(?![/\\]))+''') #$ MISSING: charSet=3:25 charSet=30:35
