
func encrypt(padding : Padding) {
	// ...

	// BAD: Using static IVs for encryption
	let iv: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05]
	let ivString = "this is a constant string"
	let key = getRandomKey()
	_ = try AES(key: key, iv: ivString)
	_ = try CBC(iv: iv)

	// GOOD: Using randomly generated IVs for encryption
	let iv = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	let ivString = String(cString: iv)
	let key = getRandomKey())
	_ = try AES(key: key, iv: ivString)
	_ = try CBC(iv: iv)

	// ...
}
