
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

// Helper functions
func getLowIterationCount() -> Int { return 99999 }

func getEnoughIterationCount() -> Int { return 120120 }

func getRandomArray() -> Array<UInt8> {
	(0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
}

// --- tests ---

func test() {
	let randomArray = getRandomArray()
	let variant = Variant.sha2
	let lowIterations = getLowIterationCount()
	let enoughIterations = getEnoughIterationCount() 
	
	// PBKDF1 test cases
	let pbkdf1b1 = PKCS5.PBKDF1(password: randomArray, salt: randomArray, iterations: lowIterations, keyLength: 0) // BAD
	let pbkdf1b2 = PKCS5.PBKDF1(password: randomArray, salt: randomArray, iterations: 80000, keyLength: 0) // BAD
	let pbkdf1g1 = PKCS5.PBKDF1(password: randomArray, salt: randomArray, iterations: enoughIterations, keyLength: 0) // GOOD
	let pbkdf1g2 = PKCS5.PBKDF1(password: randomArray, salt: randomArray, iterations: 120120, keyLength: 0) // GOOD


	// PBKDF2 test cases
	let pbkdf2b1 = PKCS5.PBKDF2(password: randomArray, salt: randomArray, iterations: lowIterations, keyLength: 0) // BAD
	let pbkdf2b2 = PKCS5.PBKDF2(password: randomArray, salt: randomArray, iterations: 80000, keyLength: 0) // BAD
	let pbkdf2g1 = PKCS5.PBKDF2(password: randomArray, salt: randomArray, iterations: enoughIterations, keyLength: 0) // GOOD
	let pbkdf2g2 = PKCS5.PBKDF2(password: randomArray, salt: randomArray, iterations: 120120, keyLength: 0) // GOOD
}
