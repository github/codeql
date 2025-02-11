function A() {
	var _a, _x = 42, _z;
	return {
		get a() {
			return _a;
		},
		set a(v) {
			
			_a = v|0
		},

		get x() {
			return _x;
		},
		set x(v) { // $ Alert
		},

		get y() {
			return 56;
		},
		set y(v) {
			
			throw new Error("Cannot mutate y.");
		},

		set z(v) {
			
			_z = arguments[0] | 0;
		}
	};
}

function Point(x, y) {
	return {
		get x() { return x; },
		set x(_x) { x = _x|0; },
		get y() { return y; },
		set y(_y) { x = _x|0; } // $ Alert
	};
}