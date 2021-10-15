// OK
[1, , 3].forEach(function(elt, idx) {
	console.log(idx + " is not omitted.");
});

// NOT OK
[1, , 3].forEach(function(elt, idx) {
	sum += elt;
});

// NOT OK
function f1(x, y) {
	return y;
}

f1(23, 42);

// OK
function f2(x, y) {
	return y;
}

[].map(f2);

// OK
function f3(x, y) {
	return y;
}

var g = f3;
[].map(g);

// OK
define(function (require, exports, module) {
	module.x = 23;
});

// OK: starts with underscore
function f(_p) {
}
