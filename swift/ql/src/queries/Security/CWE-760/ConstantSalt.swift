
func encrypt(padding : Padding) {
	// ...

	// BAD: Using constant salts for hashing
	let salt: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05]
	let randomArray = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	_ = try HKDF(password: randomArray, salt: salt, info: randomArray, keyLength: 0, variant: Variant.sha2)
	_ = try PKCS5.PBKDF1(password: randomArray, salt: salt, iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: randomArray, salt: salt, iterations: 120120, keyLength: 0)
	_ = try Scrypt(password: randomArray, salt: salt, dkLen: 64, N: 16384, r: 8, p: 1)

	// GOOD: Using randomly generated salts for hashing
	let salt = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	let randomArray = (0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
	_ = try HKDF(password: randomArray, salt: salt, info: randomArray, keyLength: 0, variant: Variant.sha2)
	_ = try PKCS5.PBKDF1(password: randomArray, salt: salt, iterations: 120120, keyLength: 0)
	_ = try PKCS5.PBKDF2(password: randomArray, salt: salt, iterations: 120120, keyLength: 0)
	_ = try Scrypt(password: randomArray, salt: salt, dkLen: 64, N: 16384, r: 8, p: 1)

	// ...
}
