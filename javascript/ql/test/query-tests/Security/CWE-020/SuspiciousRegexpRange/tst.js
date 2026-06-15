var overlap1 = /^[0-93-5]$/; // $ Alert

var overlap2 = /[A-ZA-z]/; // $ Alert

var isEmpty = /^[z-a]$/; // $ Alert

var isAscii = /^[\x00-\x7F]*$/;

var printable = /[!-~]/; // OK - used to select most printable ASCII characters

var codePoints = /[^\x21-\x7E]|[[\](){}<>/%]/g;

const NON_ALPHANUMERIC_REGEXP = /([^\#-~| |!])/g;

var smallOverlap = /[0-9a-fA-f]/; // $ Alert

var weirdRange = /[$-`]/; // $ Alert

var keywordOperator = /[!\~\*\/%+-<>\^|=&]/; // $ Alert

var notYoutube = /youtu\.be\/[a-z1-9.-_]+/; // $ Alert

var numberToLetter = /[7-F]/; // $ Alert

var overlapsWithClass1 = /[0-9\d]/; // $ Alert

var overlapsWithClass2 = /[\w,.-?:*+]/; // $ Alert

var tst2 = /^([ァ-ヾ]|[ｧ-ﾝﾞﾟ])+$/;
var tst3 = /[0-9０-９]/;

var question = /[0-?]/; // OK - matches one of: 0123456789:;<=>?

var atToZ = /[@-Z]/; // OK - matches one of: @ABCDEFGHIJKLMNOPQRSTUVWXYZ