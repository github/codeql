function Point(x, y) {
	return {
		get x() { return x; },
		set x(_x) { x = _x|0; },
		get y() { return y; },
		set y(_y) { y = _x|0; }
	};
}