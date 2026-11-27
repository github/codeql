
func encrypt(key : Key, padding : Padding) {
	// ...

	// BAD: ECB is used for block mode
	_ = try AES(key: key, blockMode: ECB(), padding: padding)
	_ = try AES(key: key, blockMode: ECB())
	_ = try Blowfish(key: key, blockMode: ECB(), padding: padding)

	// GOOD: ECB is not used for block mode
	_ = try AES(key: key, blockMode: CBC(iv: AES.randomIV(AES.blockSize)), padding: padding)
	_ = try AES(key: key, blockMode: CBC(iv: AES.randomIV(AES.blockSize)))
	_ = try Blowfish(key: key, blockMode: CBC(iv: Blowfish.randomIV(Blowfish.blockSize)), padding: padding)

	// ...
}
