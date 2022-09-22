
// --- stubs ---

// These stubs roughly follows the same structure as classes from CryptoSwift
class AES
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
}

protocol BlockMode { }

struct ECB: BlockMode { 
	init() { }
}

struct CBC: BlockMode { 
	init() { }
}

protocol PaddingProtocol { }

enum Padding: PaddingProtocol {
  case noPadding, zeroPadding, pkcs7, pkcs5, eme_pkcs1v15, emsa_pkcs1v15, iso78164, iso10126
}


// --- tests ---

func test1() {
	let key: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f]
	let ecb = ECB()
	let cbc = CBC()
	let padding = Padding.noPadding

	let b1 = AES(key: key, blockMode: ecb, padding: padding) // BAD
	let b2 = AES(key: key, blockMode: ecb) // BAD
	let b3 = AES(key: key, blockMode: ECB(), padding: padding) // BAD
	let b4 = AES(key: key, blockMode: ECB()) // BAD

	let g1 = AES(key: key, blockMode: cbc, padding: padding) // GOOD
	let g2 = AES(key: key, blockMode: cbc) // GOOD
	let g3 = AES(key: key, blockMode: CBC(), padding: padding) // GOOD
	let g4 = AES(key: key, blockMode: CBC()) // GOOD
}
