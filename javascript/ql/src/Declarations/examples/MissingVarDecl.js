function f(a) {
	var sum = 0;
	for (i=0; i<a.length; ++i)
		sum += g(a[i]);
	return sum;
}

function g(b) {
	var prod = 1;
	for (i=0; i<b.length; ++i)
		prod *= b[i];
	return prod;
}