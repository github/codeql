const x = 23, y = 42;

// NOT OK
x = 42;

// NOT OK
y = 23;

// NOT OK
var y = -1;

// NOT OK
++x;

var z = 56;

// OK
z = 72;

// OK
const s = "hi";

(function (){
    const c = null;
    for ([ c ] of o);
});
