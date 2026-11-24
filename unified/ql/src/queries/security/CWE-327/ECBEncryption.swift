
func encrypt(key : Key, padding : Padding) {
	// ...

	// BAD: ECB is used for block mode
	let blockMode = ECB()
	_ = try AES(key: key, blockMode: blockMode, padding: padding)
	_ = try AES(key: key, blockMode: blockMode)
	_ = try Blowfish(key: key, blockMode: blockMode, padding: padding)

	// GOOD: ECB is not used for block mode
	let blowfishBlockMode = CBC(iv: Blowfish.randomIV(Blowfish.blockSize))
	_ = try AES(key: key, blockMode: CBC(iv: AES.randomIV(AES.blockSize)), padding: padding)
	_ = try AES(key: key, blockMode: CBC(iv: AES.randomIV(AES.blockSize)))
	_ = try Blowfish(key: key, blockMode: blowfishBlockMode, padding: padding)

	// ...
}
