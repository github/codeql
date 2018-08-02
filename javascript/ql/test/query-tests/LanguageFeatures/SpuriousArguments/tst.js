function f() {
	var x = g();
	return x+19;
}

function g() {
	return 23;
}

// NOT OK
f(g());

function sum() {
	var result = 0;
	for (var i=0,n=arguments.length; i<n; ++i)
		result += arguments[i];
	return result;
}

// OK
sum(1, 2, 3);

function h(k) {
	k = k || function() {};
	// OK
	k(42);
}

// OK
new Array(1, 2, 3);

// NOT OK
new String(1, 2, 3);

(function(f) {
	// NOT OK
	f(42);
})(function() {});

(function h(f) {
	// OK
	f(42);
	h(function(x) { return x; });
})(function() {});

parseFloat("123", 10);