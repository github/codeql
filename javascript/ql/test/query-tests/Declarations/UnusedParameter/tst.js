
[1, , 3].forEach(function(elt, idx) {
	console.log(idx + " is not omitted.");
});

[1, , 3].forEach(function(elt, idx) { // $ Alert
	sum += elt;
});

function f1(x, y) { // $ Alert
	return y;
}

f1(23, 42);


function f2(x, y) {
	return y;
}

[].map(f2);


function f3(x, y) {
	return y;
}

var g = f3;
[].map(g);


define(function (require, exports, module) {
	module.x = 23;
});

// OK - starts with underscore
function f(_p) {
}
