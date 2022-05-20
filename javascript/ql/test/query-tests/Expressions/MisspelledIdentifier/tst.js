// use of .length to prime the query
a.length;

// NOT OK
for (var i=0; i<a.lenght; ++i);

// OK: 'correct' spelling 'eels' is not used anywhere
var eles = [];

// OK: very short identifier
var can, cna;

// OK: only case differs
var NASA, nasa;

// OK: whitelisted
var through, thru, inbetween;

// OK
var realY;

// some more priming
between, really, available, value;

// NOT OK
var lenght123, Lenght;

// OK
var LENght, JKLenght;

// NOT OK
Mandreel_HttpRequest_BytesAvalable;

// OK
EValue;

// OK
ReactDOMOther;
there;

// NO OK
var throught, through, throughout; // NB: we don't suggest "thought", since it isn't used anywhere
var sheat, cheat, sheath, sheet;
