function f(
x, // $ Alert
x, // $ Alert
\u0078
) { return; }

this.addPropertyListener(prop.name, function(_, _, _, a) {
  proxy.delegate = a.dao;
});

// OK - for strict mode functions, duplicate parameter names are a syntax error
function f(x, y, x) {
  'use strict';
}

function f(
x,
x // OK - empty function
) { }

(a, a) => a + a; // OK - for strict mode functions, duplicate parameter names are a syntax error
