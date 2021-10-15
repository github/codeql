var x;

function f(a) {
	var sum = 0;
	// NOT OK
	for (i=0; i<a.length; ++i)
		sum += g(a[i]);
	return sum;
}

function g(b) {
	var prod = 1;
	// NOT OK
	for (i=0; i<b.length; ++i)
		prod *= b[i];
	return prod;
}

function h() {
	// OK: x is declared as a global in the same toplevel
	x = 23;
	// NOT OK: y is not declared as a global in the same toplevel (though it is declared in test2.js)
	y = 19;
	// OK: console is live
	console.log(x+y);
}

function k(x) {
	try {
		return x.y;
	} catch(e) {
		// OK: Error is not reachable (in our current CFG)
		throw new Error();
	}
}

function l() {
	// OK: z is not used
	z = 56;
}

function m() {
	// OK: z is live
	z += 23;
}

function n() {
	// OK: z is live
	z = z + 23;
}

function p() {
	// NOT OK
	return (z = a[i]) && z+23;
}

function q() {
	// NOT OK
	var x;
	    y = 23,
	    z = y+19;
}

function r() {
	// NOT OK
	z = {};
	for (var p in z)
		;
}

(function() {
	for ([ unresolvable ] of o) {
		unresolvable;
	}
});
