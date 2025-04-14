
/\0/;
/\1/; // $ Alert

/^(\s+)\w+\1$/;
/^(?:\s+)\w+\1$/; // $ Alert

/[\1]/;

/^(?<ws>\s+)\w+\1$/;
/^(?<ws>\s+)\w+\k<ws>$/;
/^(?<ws>\s+)\w+\2$/; // $ Alert
/^(?<ws>\s+)\w+\k<whitespace>$/; // $ Alert
