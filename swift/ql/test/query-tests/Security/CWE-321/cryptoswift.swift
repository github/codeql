
// --- stubs ---

// These stubs roughly follows the same structure as classes from CryptoSwift
class AES
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
	init(key: String, iv: String) { }
	init(key: String, iv: String, padding: Padding) { }

	public static let blockSize: Int = 16
}

class Blowfish
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
	init(key: String, iv: String) { }
	init(key: String, iv: String, padding: Padding) { }
}

class HMAC
{
	init(key: Array<UInt8>) { }
	init(key: Array<UInt8>, variant: Variant) { }
	init(key: String) { }
	init(key: String, variant: Variant) { }
}

class ChaCha20
{
	init(key: Array<UInt8>, iv: Array<UInt8>) { }
	init(key: String, iv: String) { }
}

class CBCMAC
{
	init(key: Array<UInt8>) { }
}

class CMAC
{
	init(key: Array<UInt8>) { }
}

class Poly1305
{
	init(key: Array<UInt8>) { }
}

class Rabbit
{
	init(key: Array<UInt8>) { }
	init(key: String) { }
	init(key: Array<UInt8>, iv: Array<UInt8>) { }
	init(key: String, iv: String) { }
}

enum Variant {
	case md5, sha1, sha2, sha3
}

protocol BlockMode { }

struct CBC: BlockMode {
	init(iv: Array<UInt8>) { }
}

protocol PaddingProtocol { }

enum Padding: PaddingProtocol {
	case noPadding, zeroPadding, pkcs7, pkcs5, eme_pkcs1v15, emsa_pkcs1v15, iso78164, iso10126
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
	let key: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f]
	let key2 = getConstantArray()
	let keyString = getConstantString()

	let randomArray = getRandomArray()
	let randomKey = getRandomArray()
	let randomKeyString = String(cString: getRandomArray())

	let blockMode = CBC(iv: getRandomArray())
	let padding = Padding.noPadding
	let variant = Variant.sha2

	let iv = getRandomArray()
	let ivString = String(cString: iv)

	// AES test cases
	let ab1 = AES(key: key2, blockMode: blockMode, padding: padding) // BAD
	let ab2 = AES(key: key2, blockMode: blockMode) // BAD
	let ab3 = AES(key: keyString, iv: ivString) // BAD
	let ab4 = AES(key: keyString, iv: ivString, padding: padding) // BAD

	let ag1 = AES(key: randomKey, blockMode: blockMode, padding: padding) // GOOD
	let ag2 = AES(key: randomKey, blockMode: blockMode) // GOOD
	let ag3 = AES(key: randomKeyString, iv: ivString) // GOOD
	let ag4 = AES(key: randomKeyString, iv: ivString, padding: padding) // GOOD

	// HMAC test cases
	let hb1 = HMAC(key: key) // BAD
	let hb2 = HMAC(key: key, variant: variant) // BAD
	let hb3 = HMAC(key: keyString) // BAD
	let hb4 = HMAC(key: keyString, variant: variant) // BAD

	let hg1 = HMAC(key: randomKey) // GOOD
	let hg2 = HMAC(key: randomKey, variant: variant) // GOOD
	let hg3 = HMAC(key: randomKeyString) // GOOD
	let hg4 = HMAC(key: randomKeyString, variant: variant) // GOOD

	// ChaCha20 test cases
	let cb1 = ChaCha20(key: key, iv: iv) // BAD
	let cb2 = ChaCha20(key: keyString, iv: ivString) // BAD

	let cg1 = ChaCha20(key: randomKey, iv: iv) // GOOD
	let cg2 = ChaCha20(key: randomKeyString, iv: ivString) // GOOD

	// CBCMAC test cases
	let cmb1 = CBCMAC(key: key) // BAD

	let cmg1 = CBCMAC(key: randomKey) // GOOD

	// CMAC test cases
	let cmacb1 = CMAC(key: key) // BAD

	let cmacg1 = CMAC(key: randomKey) // GOOD

	// Poly1305 test cases
	let pb1 = Poly1305(key: key) // BAD

	let pg1 = Poly1305(key: randomKey) // GOOD

	// Blowfish test cases
	let bb1 = Blowfish(key: key, blockMode: blockMode, padding: padding) // BAD
	let bb2 = Blowfish(key: key, blockMode: blockMode) // BAD
	let bb3 = Blowfish(key: keyString, iv: ivString) // BAD
	let bb4 = Blowfish(key: keyString, iv: ivString, padding: padding) // BAD

	let bg1 = Blowfish(key: randomKey, blockMode: blockMode, padding: padding) // GOOD
	let bg2 = Blowfish(key: randomKey, blockMode: blockMode) // GOOD
	let bg3 = Blowfish(key: randomKeyString, iv: ivString) // GOOD
	let bg4 = Blowfish(key: randomKeyString, iv: ivString, padding: padding) // GOOD

	// Rabbit
	let rb1 = Rabbit(key: key) // BAD
	let rb2 = Rabbit(key: keyString) // BAD
	let rb3 = Rabbit(key: key, iv: iv) // BAD
	let rb4 = Rabbit(key: keyString, iv: ivString) // BAD

	let rg1 = Rabbit(key: randomKey) // GOOD
	let rg2 = Rabbit(key: randomKeyString) // GOOD
	let rg3 = Rabbit(key: randomKey, iv: iv) // GOOD
	let rg4 = Rabbit(key: randomKeyString, iv: ivString) // GOOD
}
