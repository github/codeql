// OK
/\0/;
// NOT OK
/\1/;
// OK
/^(\s+)\w+\1$/;
// NOT OK
/^(?:\s+)\w+\1$/;
// OK
/[\1]/;
// OK
/^(?<ws>\s+)\w+\1$/;
/^(?<ws>\s+)\w+\k<ws>$/;
// NOT OK
/^(?<ws>\s+)\w+\2$/;
/^(?<ws>\s+)\w+\k<whitespace>$/;
