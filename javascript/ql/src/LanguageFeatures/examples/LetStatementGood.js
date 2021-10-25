function sumOfSquares(a) {
	var sum = 0;
	for (var i=0; i<a.length; ++i) {
		let square = a[i]*a[i];
		sum += square;
	}
	return sum;
}
