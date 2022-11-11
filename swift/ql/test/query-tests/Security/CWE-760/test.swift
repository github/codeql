
// --- stubs ---

// These stubs roughly follows the same structure as classes from CryptoSwift
enum PKCS5 { }

enum Variant { case md5, sha1, sha2, sha3 }

extension PKCS5 {
  struct PBKDF1 {
	init(password: Array<UInt8>, salt: Array<UInt8>, variant: Variant = .sha1, iterations: Int = 4096, keyLength: Int? = nil) { }
  }

  struct PBKDF2 {
	init(password: Array<UInt8>, salt: Array<UInt8>, iterations: Int = 4096, keyLength: Int? = nil, variant: Variant = .sha2) { }
  }
}

struct HKDF {
	init(password: Array<UInt8>, salt: Array<UInt8>? = nil, info: Array<UInt8>? = nil, keyLength: Int? = nil, variant: Variant = .sha2) { }
}

final class Scrypt {
	init(password: Array<UInt8>, salt: Array<UInt8>, dkLen: Int, N: Int, r: Int, p: Int) { }
}

// Helper functions
func getConstantString() -> String {
  "this string is constant"
}

func getConstantArray() -> Array<UInt8> {
	[UInt8](getConstantString().utf8)
}

func getRandomArray() -> Array<UInt8> {
	(0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
}

// --- tests ---

func test() {
	let constantSalt: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f]
	let constantStringSalt = getConstantArray()
	let randomSalt = getRandomArray()
	let randomArray = getRandomArray()
	let variant = Variant.sha2
	let iterations = 120120
	
	// HKDF test cases
	let hkdfb1 = HKDF(password: randomArray, salt: constantSalt, info: randomArray, keyLength: 0, variant: variant) // BAD
	let hkdfb2 = HKDF(password: randomArray, salt: constantStringSalt, info: randomArray, keyLength: 0, variant: variant) // BAD [NOT DETECTED]
	let hkdfg1 = HKDF(password: randomArray, salt: randomSalt, info: randomArray, keyLength: 0, variant: variant) // GOOD

	// PBKDF1 test cases
	let pbkdf1b1 = PKCS5.PBKDF1(password: randomArray, salt: constantSalt, iterations: iterations, keyLength: 0) // BAD
	let pbkdf1b2 = PKCS5.PBKDF1(password: randomArray, salt: constantStringSalt, iterations: iterations, keyLength: 0) // BAD [NOT DETECTED]
	let pbkdf1g1 = PKCS5.PBKDF1(password: randomArray, salt: randomSalt, iterations: iterations, keyLength: 0) // GOOD


	// PBKDF2 test cases
	let pbkdf2b1 = PKCS5.PBKDF2(password: randomArray, salt: constantSalt, iterations: iterations, keyLength: 0) // BAD
	let pbkdf2b2 = PKCS5.PBKDF2(password: randomArray, salt: constantStringSalt, iterations: iterations, keyLength: 0) // BAD [NOT DETECTED]
	let pbkdf2g1 = PKCS5.PBKDF2(password: randomArray, salt: randomSalt, iterations: iterations, keyLength: 0) // GOOD

	// Scrypt test cases
	let scryptb1 = Scrypt(password: randomArray, salt: constantSalt, dkLen: 64, N: 16384, r: 8, p: 1) // BAD
	let scryptb2 = Scrypt(password: randomArray, salt: constantStringSalt, dkLen: 64, N: 16384, r: 8, p: 1) // BAD [NOT DETECTED]
	let scryptg1 = Scrypt(password: randomArray, salt: randomSalt, dkLen: 64, N: 16384, r: 8, p: 1) // GOOD
}