for (var i=0; i<10; ++i) {
	for (var j=i; i>5; --i) // $ Alert
		f(i, j);
	
	
	for (var k=0; k<i; ++k)
		f(i, k);
}