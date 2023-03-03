
func test(c: Bool, x: Int, y: Int, z: Int) {
	var v = 0

	// arithmetic operations
	v = x + y;
	v = x - 1;
	v = 2 * y;
	v = 3 / 4;
	v = x % y;
	v = -x;
	v = +x;

	// arithmetic operations with overflow
	v = x &+ y;
	v = x &- y;
	v = x &* y;
}
