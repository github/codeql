
func encrypt(padding : Padding) {
	// ...

	// BAD: Using constant passwords for hashing
	let password: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05]
	let randomArray = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	_ = try HKDF(password: password, salt: randomArray, info: randomArray, keyLength: 0, variant: Variant.sha2)
	_ = try PKCS5.PBKDF1(password: password, salt: randomArray, iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: password, salt: randomArray, iterations: 120120, keyLength: 0)
	_ = try Scrypt(password: password, salt: randomArray, dkLen: 64, N: 16384, r: 8, p: 1)

	// GOOD: Using randomly generated passwords for hashing
	let password = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	let randomArray = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	_ = try HKDF(password: password, salt: randomArray, info: randomArray, keyLength: 0, variant: Variant.sha2)
	_ = try PKCS5.PBKDF1(password: password, salt: randomArray, iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: password, salt: randomArray, iterations: 120120, keyLength: 0)
	_ = try Scrypt(password: password, salt: randomArray, dkLen: 64, N: 16384, r: 8, p: 1)

	// ...
}
