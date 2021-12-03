var reg1 = /[w-z]/; // normal range w-z, matches: wxyz
var reg2 = /[\w]/; // escape class, same as \w.
var reg3 = /[\w-z]/; // escape class \w and "-" and "z", same as [a-zA-Z0-9\-z]
var reg4 = /[\w-\w]/; // escape class \w (twice) and the char "-".
var reg5 = /[z-\w]/; // same as reg3
var reg6 = /[\n-\r]/; // from \n (code 10) to \r (code 13).
var reg7 = /[\n-z]/; // from \n (code 10) to z (code 122).
