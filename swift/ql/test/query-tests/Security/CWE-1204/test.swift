
// --- stubs ---

// These stubs roughly follows the same structure as classes from CryptoSwift
class AES
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
	init(key: String, iv: String) { }
	init(key: String, iv: String, padding: Padding) { }
}

class Blowfish
{
	init(key: Array<UInt8>, blockMode: BlockMode, padding: Padding) { }
	init(key: Array<UInt8>, blockMode: BlockMode) { }
	init(key: String, iv: String) { }
	init(key: String, iv: String, padding: Padding) { }
}

class ChaCha20
{
	init(key: Array<UInt8>, iv: Array<UInt8>) { }
	init(key: String, iv: String) { }
}

class Rabbit
{
	init(key: Array<UInt8>) { }
	init(key: String) { }
	init(key: Array<UInt8>, iv: Array<UInt8>) { }
	init(key: String, iv: String) { }
}

protocol BlockMode { }

struct CBC: BlockMode {
	init(iv: Array<UInt8>) { }
}

struct CFB: BlockMode {
	enum SegmentSize: Int {
		case cfb8 = 1
		case cfb128 = 16
	}

	init(iv: Array<UInt8>, segmentSize: SegmentSize = .cfb128) { }
}

final class GCM: BlockMode {
	enum Mode { case combined, detached }
	init(iv: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil, tagLength: Int = 16, mode: Mode = .detached) { }
	convenience init(iv: Array<UInt8>, authenticationTag: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil, mode: Mode = .detached) {
		self.init(iv: iv, additionalAuthenticatedData: additionalAuthenticatedData, tagLength: authenticationTag.count, mode: mode)
	}
}

struct OFB: BlockMode {
	init(iv: Array<UInt8>) { }
}

struct PCBC: BlockMode {
	init(iv: Array<UInt8>) { }
}

typealias StreamMode = BlockMode

struct CCM: StreamMode {
	init(iv: Array<UInt8>, tagLength: Int, messageLength: Int, additionalAuthenticatedData: Array<UInt8>? = nil) { }
	init(iv: Array<UInt8>, tagLength: Int, messageLength: Int, authenticationTag: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil) { }
}

struct CTR: StreamMode {
	init(iv: Array<UInt8>, counter: Int = 0) { }
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
	let iv: Array<UInt8> = [0x2a, 0x3a, 0x80, 0x05, 0xaf, 0x46, 0x58, 0x2d, 0x66, 0x52, 0x10, 0xae, 0x86, 0xd3, 0x8e, 0x8f]
	let iv2 = getConstantArray()
	let ivString = getConstantString()

	let randomArray = getRandomArray()
	let randomIv = getRandomArray()
	let randomIvString = String(cString: getRandomArray())

	let padding = Padding.noPadding
	let key = getRandomArray()
	let keyString = String(cString: key)

	// AES test cases
	let ab1 = AES(key: keyString, iv: ivString) // BAD
	let ab2 = AES(key: keyString, iv: ivString, padding: padding) // BAD
	let ag1 = AES(key: keyString, iv: randomIvString) // GOOD
	let ag2 = AES(key: keyString, iv: randomIvString, padding: padding) // GOOD

	// ChaCha20 test cases
	let cb1 = ChaCha20(key: keyString, iv: ivString) // BAD
	let cg1 = ChaCha20(key: keyString, iv: randomIvString) // GOOD

	// Blowfish test cases
	let bb1 = Blowfish(key: keyString, iv: ivString) // BAD
	let bb2 = Blowfish(key: keyString, iv: ivString, padding: padding) // BAD
	let bg1 = Blowfish(key: keyString, iv: randomIvString) // GOOD
	let bg2 = Blowfish(key: keyString, iv: randomIvString, padding: padding) // GOOD

	// Rabbit
	let rb1 = Rabbit(key: key, iv: iv) // BAD
	let rb2 = Rabbit(key: key, iv: iv2) // BAD
	let rb3 = Rabbit(key: keyString, iv: ivString) // BAD
	let rg1 = Rabbit(key: key, iv: randomIv) // GOOD
	let rg2 = Rabbit(key: keyString, iv: randomIvString) // GOOD

	// CBC
	let cbcb1 = CBC(iv: iv) // BAD
	let cbcg1 = CBC(iv: randomIv) // GOOD

	// CFB
	let cfbb1 = CFB(iv: iv) // BAD
	let cfbb2 = CFB(iv: iv, segmentSize: CFB.SegmentSize.cfb8) // BAD
	let cfbg1 = CFB(iv: randomIv) // GOOD
	let cfbg2 = CFB(iv: randomIv, segmentSize: CFB.SegmentSize.cfb8) // GOOD

	// GCM
	let cgmb1 = GCM(iv: iv) // BAD
	let cgmb2 = GCM(iv: iv, additionalAuthenticatedData: randomArray, tagLength: 8, mode: GCM.Mode.combined) // BAD
	let cgmb3 = GCM(iv: iv, authenticationTag: randomArray, additionalAuthenticatedData: randomArray, mode: GCM.Mode.combined) // BAD
	let cgmg1 = GCM(iv: randomIv) // GOOD
	let cgmg2 = GCM(iv: randomIv, additionalAuthenticatedData: randomArray, tagLength: 8, mode: GCM.Mode.combined) // GOOD
	let cgmg3 = GCM(iv: randomIv, authenticationTag: randomArray, additionalAuthenticatedData: randomArray, mode: GCM.Mode.combined) // GOOD

	// OFB
	let ofbb1 = OFB(iv: iv) // BAD
	let ofbg1 = OFB(iv: randomIv) // GOOD

	// PCBC
	let pcbcb1 = PCBC(iv: iv) // BAD
	let pcbcg1 = PCBC(iv: randomIv) // GOOD

	// CCM
	let ccmb1 = CCM(iv: iv, tagLength: 0, messageLength: 0, additionalAuthenticatedData: randomArray) // BAD
	let ccmb2 = CCM(iv: iv, tagLength: 0, messageLength: 0, authenticationTag: randomArray, additionalAuthenticatedData: randomArray) // BAD
	let ccmg1 = CCM(iv: randomIv, tagLength: 0, messageLength: 0, additionalAuthenticatedData: randomArray) // GOOD
	let ccmg2 = CCM(iv: randomIv, tagLength: 0, messageLength: 0, authenticationTag: randomArray, additionalAuthenticatedData: randomArray) // GOOD

	// CTR
	let ctrb1 = CTR(iv: iv) // BAD
	let ctrb2 = CTR(iv: iv, counter: 0) // BAD
	let ctrg1 = CTR(iv: randomIv) // GOOD
	let ctrg2 = CTR(iv: randomIv, counter: 0) // GOOD
}
