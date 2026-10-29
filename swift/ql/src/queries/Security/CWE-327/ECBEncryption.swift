
func encrypt(key : Key, padding : Padding) {
	// ...

	// BAD: ECB is used for block mode
	let blockMode = ECB()
	_ = try AES(key: key, blockMode: blockMode, padding: padding)
	_ = try AES(key: key, blockMode: blockMode)
	_ = try Blowfish(key: key, blockMode: blockMode, padding: padding)

	// GOOD: ECB is not used for block mode
	let aesBlockMode = CBC(iv: AES.randomIV(AES.blockSize))
	let blowfishBlockMode = CBC(iv: Blowfish.randomIV(Blowfish.blockSize))
	_ = try AES(key: key, blockMode: aesBlockMode, padding: padding)
	_ = try AES(key: key, blockMode: aesBlockMode)
	_ = try Blowfish(key: key, blockMode: blowfishBlockMode, padding: padding)

	// ...
}
