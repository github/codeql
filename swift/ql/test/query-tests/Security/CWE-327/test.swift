
// --- stubs ---

// These stubs roughly follows the same structure as classes from CryptoSwift
class AES
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
}

class Blowfish
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
}

protocol BlockMode { }

struct ECB: BlockMode {
	init() { }
}

struct CBC: BlockMode {
	init(iv: Array<UInt8>) { }
}

protocol PaddingProtocol { }

enum Padding: PaddingProtocol {
  case noPadding, zeroPadding, pkcs7, pkcs5, eme_pkcs1v15, emsa_pkcs1v15, iso78164, iso10126
}

// Create some inter-procedural dependencies

func getRandomArray() -> Array<UInt8> {
	(0..<10).map({ _ in UInt8.random(in: 0...UInt8.max) })
}

func getECBBlockMode() -> BlockMode {
	return ECB()
}

func getCBCBlockMode() ->  BlockMode {
	return CBC(iv: getRandomArray())
}

// --- tests ---

func test1() {
	let key: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f]
	let ecb = ECB()
	let iv = getRandomArray()
	let cbc = CBC(iv: iv)
	let padding = Padding.noPadding

	// AES test cases
	let ab1 = AES(key: key, blockMode: ecb, padding: padding) // BAD
	let ab2 = AES(key: key, blockMode: ecb) // BAD
	let ab3 = AES(key: key, blockMode: ECB(), padding: padding) // BAD
	let ab4 = AES(key: key, blockMode: ECB()) // BAD
	let ab5 = AES(key: key, blockMode: getECBBlockMode(), padding: padding) // BAD
	let ab6 = AES(key: key, blockMode: getECBBlockMode()) // BAD

	let ag1 = AES(key: key, blockMode: cbc, padding: padding) // GOOD
	let ag2 = AES(key: key, blockMode: cbc) // GOOD
	let ag3 = AES(key: key, blockMode: CBC(iv: iv), padding: padding) // GOOD
	let ag4 = AES(key: key, blockMode: CBC(iv: iv)) // GOOD
	let ag5 = AES(key: key, blockMode: getCBCBlockMode(), padding: padding) // GOOD
	let ag6 = AES(key: key, blockMode: getCBCBlockMode()) // GOOD

	// Blowfish test cases
	let bb1 = Blowfish(key: key, blockMode: ecb, padding: padding) // BAD
	let bb2 = Blowfish(key: key, blockMode: ECB(), padding: padding) // BAD
	let bb3 = Blowfish(key: key, blockMode: getECBBlockMode(), padding: padding) // BAD

	let bg1 = Blowfish(key: key, blockMode: cbc, padding: padding) // GOOD
	let bg2 = Blowfish(key: key, blockMode: CBC(iv: iv), padding: padding) // GOOD
	let bg3 = Blowfish(key: key, blockMode: getCBCBlockMode(), padding: padding) // GOOD
}
