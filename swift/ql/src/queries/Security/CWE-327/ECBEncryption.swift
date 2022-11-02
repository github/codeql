
func encrypt(key : Key, padding : Padding) {
	// ...

	// BAD: ECB is used for block mode
	let blockMode = ECB()
	_ = try AES(key: key, blockMode: blockMode, padding: padding)
	_ = try AES(key: key, blockMode: blockMode)
	_ = try Blowfish(key: key, blockMode: blockMode, padding: padding)

	// GOOD: ECB is not used for block mode
	let blockMode = CBC()
	_ = try AES(key: key, blockMode: blockMode, padding: padding)
	_ = try AES(key: key, blockMode: blockMode)
	_ = try Blowfish(key: key, blockMode: blockMode, padding: padding)

	// ...
}
