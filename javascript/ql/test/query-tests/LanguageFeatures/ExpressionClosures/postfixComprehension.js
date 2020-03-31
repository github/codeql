var numbers = [1, 2, 3, 4, 5];
var squares = [i*i for (i of numbers)];
var specialKeyCodes = [for (keyCodeName of Object.keys(SPECIAL_CODES_MAP))
    SPECIAL_CODES_MAP[keyCodeName]];
