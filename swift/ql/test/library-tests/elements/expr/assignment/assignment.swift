
func test() {
	var x = 0

	// simple assignment
	x = 1

	// arithmetic assignment operations
	x += 1
	x -= 1
	x *= 1
	x /= 1
	x %= 1

	// bitwise assignment operations
	x &= 1
	x |= 1
	x ^= 1
	x <<= 1
	x >>= 1

	// assignment operations with overflow
	x &*= 1
	x &+= 1
	x &-= 1
	x &<<= 1
	x &>>= 1

	// pointwise assignment operations
	var y = SIMD4<Int>(1, 2, 3, 4)
	let z = SIMD4<Int>(5, 6, 7, 8)
	var m = y .< z
	y = z
	m .&= m
	m .|= m
	m .^= m
}
