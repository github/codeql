// NOT OK
typeof a === 'array';

// OK
typeof b == 'string';

// OK
typeof c != "string";

// OK
"number" !== typeof 23;

// OK
'object' == typeof null;

// OK
typeof es6 === 'symbol';

switch (typeof a) {
// OK
case 'undefined':
// NOT OK
case 'null':
}

// OK
switch (msg) {
case 'null':
case typeof a:
}

// NOT OK
(typeof a) === 'array';

// JScript extensions
typeof a === 'unknown' || typeof a === 'date';

// bigints, TC39 Stage 3 as of 2018-02-13
typeof a === 'bigint'
