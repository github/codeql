for (var i=0; i<10; ++i) {
	// NOT OK
	for (var j=i; j>5; --j)
		f(i, j);
}