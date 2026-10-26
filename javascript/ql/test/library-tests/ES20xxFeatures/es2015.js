// modules
import foo from 'bar';

function foo(
  x = 23,               // default function parameters
  ...rest               // rest parameters
) {}

Math.max(...[1, 2, 3]); // spread (...) operator

var x = 23;
var o = {
  __proto__: [],        // object literal extensions
  x,                    // object literal extensions
  foo() {},             // object literal extensions
  [x]: x                // object literal extensions
};

for (var x of xs);      // for..of loops

0b11001001;             // octal and binary literals
0o2412;                 // octal and binary literals

`template`;             // template literals

/a/y;                   // RegExp "y" and "u" flags
/a/u;                   // RegExp "y" and "u" flags

var [y] = o;            // destructuring declarations
[y] = y;                // destructuring assignment
(function (
  {x:y}                 // destructuring parameters
) {})(o);

"\u{1f63c}";            // Unicode code point escapes
"\udead";
"\\u{1f63c}";


const pi = 22/7;        // const
let z = x+1;            // let

[1, 2, 3].map(
  x => x*2              // arrow functions
); 

class Super {           // class
  constructor(x) { console.log(x); }
}

class Sub {             // class
  constructor() {
    super(42);          // super
  }
}

function* gen() {       // generators
  yield 42;             // generators
  yield* gen;           // generators
  new.target;           // new.target
}

!class extends Super {} // class