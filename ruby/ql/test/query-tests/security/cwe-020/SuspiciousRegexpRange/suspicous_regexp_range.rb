overlap1 = /^[0-93-5]$/ # $ Alert // NOT OK

overlap2 = /[A-ZA-z]/ # $ Alert // NOT OK

isEmpty = /^[z-a]$/ # $ Alert // NOT OK

isAscii = /^[\x00-\x7F]*$/ # OK

printable = /[!-~]/ # OK - used to select most printable ASCII characters

codePoints = /[^\x21-\x7E]|[\[\](){}<>\/%]/ # OK

NON_ALPHANUMERIC_REGEXP = /([^\#-~| |!])/ # OK

smallOverlap = /[0-9a-fA-f]/ # $ Alert // NOT OK

weirdRange = /[$-`]/ # $ Alert // NOT OK

keywordOperator = /[!\~\*\/%+-<>\^|=&]/ # $ Alert // NOT OK

notYoutube = /youtu\.be\/[a-z1-9.-_]+/ # $ Alert // NOT OK

numberToLetter = /[7-F]/ # $ Alert // NOT OK

overlapsWithClass1 = /[0-9\d]/ # $ Alert // NOT OK

overlapsWithClass2 = /[\w,.-?:*+]/ # $ Alert // NOT OK

escapes = /[\000-\037\047\134\177-\377]/n # OK - they are escapes

nested = /[a-z&&[^a-c]]/ # OK

overlapsWithNothing = /[\w_%-.]/; # $ Alert
