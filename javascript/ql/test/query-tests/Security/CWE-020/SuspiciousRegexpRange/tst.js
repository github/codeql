var overlap1 = /^[0-93-5]$/; // NOT OK

var overlap2 = /[A-ZA-z]/; // NOT OK

var isEmpty = /^[z-a]$/; // NOT OK

var isAscii = /^[\x00-\x7F]*$/; // OK

var printable = /[!-~]/; // OK - used to select most printable ASCII characters

var codePoints = /[^\x21-\x7E]|[[\](){}<>/%]/g; // OK 

const NON_ALPHANUMERIC_REGEXP = /([^\#-~| |!])/g; // OK

var smallOverlap = /[0-9a-fA-f]/; // NOT OK

var weirdRange = /[$-`]/; // NOT OK

var keywordOperator = /[!\~\*\/%+-<>\^|=&]/; // NOT OK

var notYoutube = /youtu\.be\/[a-z1-9.-_]+/; // NOT OK

var numberToLetter = /[7-F]/; // NOT OK

var overlapsWithClass1 = /[0-9\d]/; // NOT OK

var overlapsWithClass2 = /[\w,.-?:*+]/; // NOT OK

var tst2 = /^([ァ-ヾ]|[ｧ-ﾝﾞﾟ])+$/; // OK
var tst3 = /[0-9０-９]/; // OK

var question = /[0-?]/; // OK. matches one of: 0123456789:;<=>?

var atToZ = /[@-Z]/; // OK. matches one of: @ABCDEFGHIJKLMNOPQRSTUVWXYZ