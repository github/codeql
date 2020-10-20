// NOT OK
!method in obj;

// OK
!(method in obj);

// OK
'__proto__' in obj;

// OK
0 in obj;

// OK
('$' + key) in obj;

// NOT OK
p in null;

// NOT OK
0 in 'string';

// OK
p in {};

// NOT OK
console.log("Setting device's bluetooth name to '%s'" % device_name);

// NOT OK
if (!callback || !callback instanceof Function) {
    ;
}

// OK
function cmp(x, y) {
    return (x > y) - (x < y);
}

// OK
function cmp(x, y) {
    if (x > y)
        return 1;
    if (x < y)
        return -1;
    return 0;
}

// OK
function cmp(x, y) {
    return (x > y) - (x < y);
}

// NOT OK
1 + void 0

// OK
o[true] = 42;

function f() {
  var x;
  // NOT OK
  x -= 2;
}

function g() {
  var x = 19, y;
  // NOT OK
  x %= y;
}

function h() {
  var x;
  // NOT OK
  ++x;
}

function k() {
  var name;
  // NOT OK
  return `Hello ${name}!`;
}

function l() {
  var x;
  // NOT OK
  x ** 2;
}

1n + 1; // NOT OK, but not currently flagged

(function(){
    let sum = 0;
    for ({value} of async(o)) {
        sum += value;
    }
});

(function(){
    function f() {
    }
    f()|0;

    unknown()|0;

    function g() {
    }
    g()|0;
    g();

    var a = g() + 2;
    var b = g() + "str";
});


function m() {
  var x = 19, y = "string";
  
  x %= y; // NOT OK
  x += y; // OK 
  x ||= y; // OK
  x &&= y; // OK
  x ??= y; // OK
  x >>>= y; // NOT OK
}
