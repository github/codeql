
func encrypt(padding : Padding) {
	// ...

	// BAD: Using hardcoded keys for encryption
	let key: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05]
	let keyString = "this is a constant string"
	let ivString = getRandomIV()
	_ = try AES(key: key, blockMode: CBC(), padding: padding)
	_ = try AES(key: keyString, iv: ivString)
	_ = try Blowfish(key: key, blockMode: CBC(), padding: padding)
	_ = try Blowfish(key: keyString, iv: ivString)


	// GOOD: Using randomly generated keys for encryption
	let key = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	let keyString = String(cString: key)
	let ivString = getRandomIV()
	_ = try AES(key: key, blockMode: CBC(), padding: padding)
	_ = try AES(key: keyString, iv: ivString)
	_ = try Blowfish(key: key, blockMode: CBC(), padding: padding)
	_ = try Blowfish(key: keyString, iv: ivString)

	// ...
}
