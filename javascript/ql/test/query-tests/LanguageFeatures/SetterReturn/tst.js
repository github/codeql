var o = {
	_secret_x: 42,
	get x() {
		// OK
		return 42;
	},
	set x(v) {
		if (v !== 42)
			// OK
			return;
		_secret_x = v;
	},
	set y(w) {
		// NOT OK
		return "nope";
	}
}