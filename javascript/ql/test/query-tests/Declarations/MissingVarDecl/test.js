var x;

function f(a) {
	var sum = 0;
	for (i=0; i<a.length; ++i) // $ Alert
		sum += g(a[i]);
	return sum;
}

function g(b) {
	var prod = 1;
	for (i=0; i<b.length; ++i) // $ Alert
		prod *= b[i];
	return prod;
}

function h() {
	// OK - x is declared as a global in the same toplevel
	x = 23;
	y = 19; // $ Alert - y is not declared as a global in the same toplevel (though it is declared in test2.js)
	// OK - console is live
	console.log(x+y);
}

function k(x) {
	try {
		return x.y;
	} catch(e) {
		// OK - Error is not reachable (in our current CFG)
		throw new Error();
	}
}

function l() {
	// OK - z is not used
	z = 56;
}

function m() {
	// OK - z is live
	z += 23;
}

function n() {
	// OK - z is live
	z = z + 23;
}

function p() {
	return (z = a[i]) && z+23; // $ Alert
}

function q() {
	var x;
	    y = 23, // $ Alert
	    z = y+19;
}

function r() {
	z = {}; // $ Alert
	for (var p in z)
		;
}

(function() {
	for ([ unresolvable ] of o) { // $ Alert
		unresolvable;
	}
});
