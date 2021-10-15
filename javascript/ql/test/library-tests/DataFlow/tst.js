import { fs } from 'fs';

let x = 42;
let y = "hi";
let z;

fs;                               // def-use flow
x;                                // def-use flow
(x);                              // flow through parentheses
x, y;                             // flow through comma operator
x && y;                           // flow through short-circuiting operator
x || y;                           // flow through short-circuiting operator
z = y;                            // flow through assignment
z ? x : y;                        // flow through conditional operator

(function f(a) {                  // flow into IIFE
  if (Math.random() > 0.5)
    return a;
  return "";
})("arg");                        // flow out of IIFE

let { readFileSync } = fs;
readFileSync;                     // flow out of destructuring assignment

++x;
x;                                // def-use flow

(() =>
  x                               // imprecise def-use flow for captured variables
)();

function g(b) {                   // no flow through general calls
  return x;                       // imprecise def-use flow for captured variables
}
g(true);                          // no flow through general calls

var o = {
  x: null,
  m() {
    this;
  }
};
o.x;                              // no flow through properties
o.m();                            // no flow through method calls

global = "";
global;                           // no flow through global variables

class A extends B {
  constructor() {
    super(42);                    // no attempt is made to resolve `super`
    new.target;                   // or `new.target`
  }
}
A;                                // def-use flow

`x: ${x}`;
tag `x: ${x}`;                    // tagged templates are not analysed

g;                                // def-use flow
::o.m;                            // function-bind is not analysed
o::g;                             // function-bind is not analysed

function* h() {
  yield 42;                       // `yield` is not analysed
  var tmp = function.sent;        // `function.sent` is not analysed
}
let iter = h();
iter.next(23);

async function k() {
  await p();                      // `await` is not analysed
}

let m = import('foo');            // dynamic `import` is not analysed

for (let i in o)                  // for-in loops are not analysed
  i;

for (let v of o)                  // for-of loops are not analysed
  v;

var vs1 = [ for (v of o) v ];     // array comprehensions are not analysed

var vs2 = ( for (v of o) v );     // generator comprehensions are not analysed

(function({ p: x, ...o }) {
  let { q: y } = o;
  var z;
  ({ r: z } = o);
  return x + y + z;
})({
  p: 19,
  q: 23,
  r: 0
});

(function([ x, ...rest ]) {
  let [ y ] = rest;
  var z;
  [ , z ] = rest;
  return x + y + z;
})([ 19, 23, 0 ]);

x ?? y;                           // flow through short-circuiting operator

(function(){
	var {v1a, v1b = o1b, v1c = o1c} = o1d;
	v1a + v1b + v1c;

	var [v2a, v2b = o2b, v2c = o2c] = o2d;
	v2a + v2b + v2c;
});

Array.call()  // flow from implicit call to `Array` to `Array.call`

var x2 = Object.seal(x1) // flow through identity function
