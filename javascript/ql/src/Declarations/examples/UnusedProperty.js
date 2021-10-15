function f() {
	var o = {
		prop_a: expensiveComputation(),
		prop_b: anotherComputation()
	};

	return o.prop_b;
}
