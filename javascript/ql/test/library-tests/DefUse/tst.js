function f(o) {
	var x, y = 23, i = 0;
	for (x in o)
		++i;
	for (var z in o)
		if (z)
			--i;
	console.log(z, y);
}

(function g() {
	x = 42;
	var x;
	return x;
});

(function(x) {
	return x;
	function x() {}
});

(function(){
	var {a = b, c = d} = e;
	a + c;
});
(function(a = b) {
	a;
});
