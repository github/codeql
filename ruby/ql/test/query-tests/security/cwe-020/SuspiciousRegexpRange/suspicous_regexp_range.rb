overlap1 = /^[0-93-5]$/ # NOT OK

overlap2 = /[A-ZA-z]/ # NOT OK

isEmpty = /^[z-a]$/ # NOT OK

isAscii = /^[\x00-\x7F]*$/ # OK

printable = /[!-~]/ # OK - used to select most printable ASCII characters

codePoints = /[^\x21-\x7E]|[\[\](){}<>\/%]/ # OK

NON_ALPHANUMERIC_REGEXP = /([^\#-~| |!])/ # OK

smallOverlap = /[0-9a-fA-f]/ # NOT OK

weirdRange = /[$-`]/ # NOT OK

keywordOperator = /[!\~\*\/%+-<>\^|=&]/ # NOT OK

notYoutube = /youtu\.be\/[a-z1-9.-_]+/ # NOT OK

numberToLetter = /[7-F]/ # NOT OK

overlapsWithClass1 = /[0-9\d]/ # NOT OK

overlapsWithClass2 = /[\w,.-?:*+]/ # NOT OK

escapes = /[\000-\037\047\134\177-\377]/n # OK - they are escapes

nested = /[a-z&&[^a-c]]/ # OK
