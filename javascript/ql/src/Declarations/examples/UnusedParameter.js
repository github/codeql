function f(x, y) {
	var _y = expensiveComputation(x);
	use(x, _y);
}

var x = 42;
f(x, expensiveComputation(x));