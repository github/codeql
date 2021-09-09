import re


re.compile(r'[A-Z]') #$ charRange=1:2-3:4

try:
    re.compile(r'[]-[]') #$ SPURIOUS: charRange=1:2-3:4
    raise Exception("this should not be reached")
except re.error:
    pass

re.compile(r'[---]') #$ charRange=1:2-3:4
re.compile(r'[\---]') #$ charRange=1:3-4:5
re.compile(r'[--\-]') #$ charRange=1:2-3:5
re.compile(r'[\--\-]') #$ charRange=1:3-4:6
re.compile(r'[0-9-A-Z]') #$ charRange=1:2-3:4 charRange=5:6-7:8
re.compile(r'[0\-9-A-Z]') #$ charRange=4:5-6:7

try:
    re.compile(r'[0--9-A-Z]') #$ SPURIOUS: charRange=1:2-3:4 charRange=4:5-6:7
    raise Exception("this should not be reached")
except re.error:
    pass

re.compile(r'[^A-Z]') #$ charRange=2:3-4:5

re.compile(r'[\0-\09]') #$ charRange=1:3-4:6
re.compile(r'[\0-\07]') #$ charRange=1:3-4:7

re.compile(r'[\0123-5]') #$ charRange=5:6-7:8


#Negative lookahead
re.compile(r'(?!not-this)^[A-Z_]+$') #$ charRange=14:15-16:17
#Negative lookbehind
re.compile(r'^[A-Z_]+$(?<!not-this)') #$ charRange=2:3-4:5


#OK -- ODASA-ODASA-3968
re.compile('(?:[^%]|^)?%\((\w*)\)[a-z]') #$ charRange=22:23-24:25

#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]') #$ charRange=1:2-3:4 charRange=6:7-8:9
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]') #$ charRange=1:2-3:4
