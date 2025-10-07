!method in obj; // $ Alert


!(method in obj);


'__proto__' in obj;


0 in obj;


('$' + key) in obj;

p in null; // $ Alert

0 in 'string'; // $ Alert


p in {};

console.log("Setting device's bluetooth name to '%s'" % device_name); // $ Alert

if (!callback || !callback instanceof Function) { // $ Alert
    ;
}


function cmp(x, y) {
    return (x > y) - (x < y);
}


function cmp(x, y) {
    if (x > y)
        return 1;
    if (x < y)
        return -1;
    return 0;
}


function cmp(x, y) {
    return (x > y) - (x < y);
}

1 + void 0 // $ Alert


o[true] = 42;

function f() {
  var x;
  x -= 2; // $ Alert
}

function g() {
  var x = 19, y;
  x %= y; // $ Alert
}

function h() {
  var x;
  ++x; // $ Alert
}

function k() {
  var name;
  return `Hello ${name}!`; // $ Alert
}

function l() {
  var x;
  x ** 2; // $ Alert
}

1n + 1; // $ MISSING: Alert

(function(){
    let sum = 0;
    for ({value} of async(o)) {
        sum += value;
    }
});

(function(){
    function f() {
    }
    f()|0; // $ Alert

    unknown()|0;

    function g() {
    }
    g()|0; // $ Alert
    g();

    var a = g() + 2; // $ Alert
    var b = g() + "str"; // $ Alert
});


function m() {
  var x = 19, y = "string";
  
  x %= y; // $ Alert
  x += y;
  x ||= y;
  x &&= y;
  x ??= y;
  x >>>= y; // $ Alert
}
