import re

overlap1 = re.compile(r'^[0-93-5]$') # NOT OK

overlap2 = re.compile(r'[A-ZA-z]') # NOT OK

isEmpty = re.compile(r'^[z-a]$') # NOT OK

isAscii = re.compile(r'^[\x00-\x7F]*$') # OK

printable = re.compile(r'[!-~]') # OK - used to select most printable ASCII characters

codePoints = re.compile(r'[^\x21-\x7E]|[[\](){}<>/%]') # OK

NON_ALPHANUMERIC_REGEXP = re.compile(r'([^\#-~| |!])') # OK

smallOverlap = re.compile(r'[0-9a-fA-f]') # NOT OK

weirdRange = re.compile(r'[$-`]') # NOT OK

keywordOperator = re.compile(r'[!\~\*\/%+-<>\^|=&]') # NOT OK

notYoutube = re.compile(r'youtu\.be\/[a-z1-9.-_]+') # NOT OK

numberToLetter = re.compile(r'[7-F]') # NOT OK

overlapsWithClass1 = re.compile(r'[0-9\d]') # NOT OK

overlapsWithClass2 = re.compile(r'[\w,.-?:*+]') # NOT OK

unicodeStuff =  re.compile('[\U0001D173-\U0001D17A\U000E0020-\U000E007F\U000e0001]') # NOT OK