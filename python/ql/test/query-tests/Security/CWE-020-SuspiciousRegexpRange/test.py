import re

overlap1 = re.compile(r'^[0-93-5]$') # $ Alert # NOT OK

overlap2 = re.compile(r'[A-ZA-z]') # $ Alert # NOT OK

isEmpty = re.compile(r'^[z-a]$') # $ Alert # NOT OK

isAscii = re.compile(r'^[\x00-\x7F]*$') # OK

printable = re.compile(r'[!-~]') # OK - used to select most printable ASCII characters

codePoints = re.compile(r'[^\x21-\x7E]|[[\](){}<>/%]') # OK

NON_ALPHANUMERIC_REGEXP = re.compile(r'([^\#-~| |!])') # OK

smallOverlap = re.compile(r'[0-9a-fA-f]') # $ Alert # NOT OK

weirdRange = re.compile(r'[$-`]') # $ Alert # NOT OK

keywordOperator = re.compile(r'[!\~\*\/%+-<>\^|=&]') # $ Alert # NOT OK

notYoutube = re.compile(r'youtu\.be\/[a-z1-9.-_]+') # $ Alert # NOT OK

numberToLetter = re.compile(r'[7-F]') # $ Alert # NOT OK

overlapsWithClass1 = re.compile(r'[0-9\d]') # $ Alert # NOT OK

overlapsWithClass2 = re.compile(r'[\w,.-?:*+]') # $ Alert # NOT OK

unicodeStuff =  re.compile('[\U0001D173-\U0001D17A\U000E0020-\U000E007F\U000e0001]') # $ Alert # NOT OK
