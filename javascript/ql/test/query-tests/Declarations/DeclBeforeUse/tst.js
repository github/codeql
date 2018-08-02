function f(x) {
	switch (x) {
	case 23:
		var y = x+19;
		return y;
	default:
		var y = 42;
		return g(y);
	}
}

function g() {
	return f(y-19);
}