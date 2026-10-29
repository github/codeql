var o = {
	_secret_x: 42,
	get x() {
		
		return 42;
	},
	set x(v) {
		if (v !== 42)
			
			return;
		_secret_x = v;
	},
	set y(w) {
		return "nope"; // $ Alert
	}
}