for (var i=0; i<10; ++i) {
	// NOT OK
	for (var j=i; i>5; --i)
		f(i, j);
	
	// OK
	for (var k=0; k<i; ++k)
		f(i, k);
}