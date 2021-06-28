import re

re.compile(r'[]-[]') #$ MISSING: charRange=1:2-3:4
re.compile(r'[---]') #$ MISSING: charRange=1:2-3:4
re.compile(r'[\---]') #$ MISSING: charRange=1:3-4:5
re.compile(r'[--\-]') #$ MISSING: charRange=1:2-3:5
re.compile(r'[\--\-]') #$ cMISSING: harRange=1:3-4:6
re.compile(r'[0-9-A-Z]') #$ MISSING: charRange=1:2-3:4 charRange=5:6-7:8
re.compile(r'[0\-9-A-Z]') #$ MISSING: charRange=4:5-6:7
re.compile(r'[0--9-A-Z]') #$ MISSING: charRange=1:2-3:4 charRange=4:5-6:7

re.compile(r'[^A-Z]') #$ MISSING: charRange=2:3-4:5

re.compile(r'[\0-\09]') #$ MISSING: charRange=1:3-4:7

re.compile(r'[\0123-5]') #$ MISSING: charRange=5:6-7:8


#Negative lookahead
re.compile(r'(?!not-this)^[A-Z_]+$') #$ MISSING: charRange=14:15-16:17
#Negative lookbehind
re.compile(r'^[A-Z_]+$(?<!not-this)') #$ MISSING: charRange=2:3-4:5


#OK -- ODASA-ODASA-3968
re.compile('(?:[^%]|^)?%\((\w*)\)[a-z]') #$ MISSING: charRange=22:23-24:25

#ODASA-3985
#Half Surrogate pairs
re.compile(u'[\uD800-\uDBFF][\uDC00-\uDFFF]') #$ MISSING: charRange=1:2-3:4 charRange=6:7-8:9
#Outside BMP
re.compile(u'[\U00010000-\U0010ffff]') #$ MISSING: charRange=1:2-3:4
