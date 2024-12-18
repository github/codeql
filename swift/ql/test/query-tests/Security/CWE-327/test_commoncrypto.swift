// --- stubs ---

struct Data {
	func withUnsafeBytes<ResultType>(
		_ body: (UnsafeRawBufferPointer) throws -> ResultType
		) rethrows -> ResultType { return 0 as! ResultType }
	mutating func withUnsafeMutableBytes<ResultType>(
		_ body: (UnsafeMutableRawBufferPointer) throws -> ResultType
		) rethrows -> ResultType { return 0 as! ResultType }
}

// --- CommonCryptor ---
// (real world projects will import the CommonCryptor headers which get
//  converted to Swift by the compiler; the following is an approximation
//  of that derived from QL queries and the CommonCryptor header files)

var kCCSuccess : Int = 0
typealias CCCryptorStatus = Int32

typealias CCCryptorRef = OpaquePointer

var kCCEncrypt : Int = 0
var kCCDecrypt : Int = 1
typealias CCOperation = UInt32

var kCCAlgorithmAES128 : Int = 0
var kCCAlgorithmAES : Int = 0
var kCCAlgorithmDES : Int = 1
var kCCAlgorithm3DES : Int = 2
var kCCAlgorithmCAST : Int = 3
var kCCAlgorithmRC4 : Int = 4
var kCCAlgorithmRC2 : Int = 5
var kCCAlgorithmBlowfish : Int = 6
typealias CCAlgorithm = UInt32

var kCCOptionPKCS7Padding : Int = 1
var kCCOptionECBMode : Int = 2
typealias CCOptions = UInt32

var kCCModeECB : Int = 1
var kCCModeCBC : Int = 2
var kCCModeCFB : Int = 3
var kCCModeCTR : Int = 4
var kCCModeOFB : Int = 7
var kCCModeRC4 : Int = 9
var kCCModeCFB8 : Int = 10
typealias CCMode = UInt32

typealias CCPadding = UInt32

typealias CCModeOptions = UInt32

func CCCryptorCreate(
	_ op: CCOperation,
	_ alg: CCAlgorithm,
	_ options: CCOptions,
	_ key: UnsafeRawPointer?,
	_ keyLength: Int,
	_ iv: UnsafeRawPointer?,
	_ cryptorRef: UnsafeMutablePointer<CCCryptorRef?>?
	) -> CCCryptorStatus { return 0 }

func CCCryptorCreateFromData(
	_ op: CCOperation,
	_ alg: CCAlgorithm,
	_ options: CCOptions,
	_ key: UnsafeRawPointer?,
	_ keyLength: Int,
	_ iv: UnsafeRawPointer?,
	_ data: UnsafeRawPointer?,
	_ dataLength: Int,
	_ cryptorRef: UnsafeMutablePointer<CCCryptorRef?>?,
	_ dataUsed: UnsafeMutablePointer<Int>?
	) -> CCCryptorStatus { return 0 }

func CCCryptorCreateWithMode(
	_ op: CCOperation,
	_ mode: CCMode,
	_ alg: CCAlgorithm,
	_ padding: CCPadding,
	_ iv: UnsafeRawPointer?,
	_ key: UnsafeRawPointer?,
	_ keyLength: Int,
	_ tweak: UnsafeRawPointer?,
	_ tweakLength: Int,
	_ numRounds: Int32,
	_ options: CCModeOptions,
	_ cryptorRef: UnsafeMutablePointer<CCCryptorRef?>?
	) -> CCCryptorStatus { return 0 }

func CCCryptorUpdate(
	_ cryptorRef: CCCryptorRef?,
	_ dataIn: UnsafeRawPointer?,
	_ dataInLength: Int,
	_ dataOut: UnsafeMutableRawPointer?,
	_ dataOutAvailable: Int,
	_ dataOutMoved: UnsafeMutablePointer<Int>?
	) -> CCCryptorStatus { return 0 }

func CCCryptorFinal(
	_ cryptorRef: CCCryptorRef?,
	_ dataOut: UnsafeMutableRawPointer?,
	_ dataOutAvailable: Int,
	_ dataOutMoved: UnsafeMutablePointer<Int>?
	) -> CCCryptorStatus { return 0 }

func CCCrypt(
	_ op: CCOperation,
	_ alg: CCAlgorithm,
	_ options: CCOptions,
	_ key: UnsafeRawPointer?,
	_ keyLength: Int,
	_ iv: UnsafeRawPointer?,
	_ dataIn: UnsafeRawPointer?,
	_ dataInLength: Int,
	_ dataOut: UnsafeMutableRawPointer?,
	_ dataOutAvailable: Int,
	_ dataOutMoved: UnsafeMutablePointer<Int>?
	) -> CCCryptorStatus { return 0 }

// --- tests ---

func cond() -> Bool { return true }

func test_commoncrypto1(key: Data, iv: Data, dataIn: Data, dataOut: inout Data) {
	// semi-realistic test case
	var myCryptor: CCCryptorRef?
	var dataOutWritten = 0

	/*key.withUnsafeBytes({
		keyPtr in
		iv.withUnsafeBytes({
			// create the cryptor object
			ivPtr in
			let result1 = CCCryptorCreate(
				CCOperation(kCCEncrypt),
				CCAlgorithm(kCCAlgorithm3DES), // BAD [NOT DETECTED]
				CCOptions(0),
				keyPtr.baseAddress!,
				keyPtr.count,
				ivPtr.baseAddress!,
				&myCryptor
			)
			guard result1 == CCCryptorStatus(kCCSuccess) else {
				return // fail
			}

			dataIn.withUnsafeBytes({
				dataInPtr in
				dataOut.withUnsafeMutableBytes({
					dataOutPtr in
					// encrypt data
					while (cond()) {
						let result2 = CCCryptorUpdate(
							myCryptor,
							dataInPtr.baseAddress!,
							dataInPtr.count,
							dataOutPtr.baseAddress!,
							dataOutPtr.count,
							&dataOutWritten)
						guard result2 == CCCryptorStatus(kCCSuccess) else {
							return // fail
						}
					}

					// finish
					let result3 = CCCryptorFinal(
						myCryptor,
						dataOutPtr.baseAddress!,
						dataOutPtr.count,
						&dataOutWritten)
					guard result3 == CCCryptorStatus(kCCSuccess) else {
						return // fail
					}
				})
			})
		})
	})*/
}

func test_commoncrypto2(
	key: UnsafeRawPointer, keyLen: Int,
	iv: UnsafeRawPointer,
	dataIn: UnsafeRawPointer, dataInLen: Int,
	dataOut: UnsafeMutableRawPointer, dataOutAvail: Int) {
	var myCryptor: CCCryptorRef?
	var dataOutWritten = 0

	// algorithms
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES128), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmDES), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil) // BAD [NOT DETECTED]
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithm3DES), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil) // BAD [NOT DETECTED]
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmCAST), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmRC4), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil) // BAD [NOT DETECTED]
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmRC2), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil) // BAD [NOT DETECTED]
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmBlowfish), 0, key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCryptorCreate(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithm3DES), 0, key, keyLen, iv, &myCryptor) // BAD [NOT DETECTED]
	_ = CCCryptorCreateFromData(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithm3DES), 0, key, keyLen, iv, dataIn, dataInLen, &myCryptor, &dataOutWritten) // BAD [NOT DETECTED]
	_ = CCCryptorCreateFromData(CCOperation(kCCDecrypt), CCAlgorithm(kCCAlgorithm3DES), 0, key, keyLen, iv, dataIn, dataInLen, &myCryptor, &dataOutWritten) // BAD [NOT DETECTED]

	// block modes (the default is CBC)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(0), key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding), key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil)
	_ = CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionECBMode), key, keyLen, iv, dataIn, dataInLen, dataOut, dataOutAvail, nil) // BAD [NOT DETECTED]
	_ = CCCryptorCreate(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithm3DES), CCOptions(kCCOptionECBMode), key, keyLen, iv, &myCryptor) // BAD [NOT DETECTED]
	_ = CCCryptorCreateFromData(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithm3DES), CCOptions(kCCOptionECBMode), key, keyLen, iv, dataIn, dataInLen, &myCryptor, &dataOutWritten) // BAD [NOT DETECTED]

	// modes
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeECB), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor) // BAD [NOT DETECTED]
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeCBC), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeCFB), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeCTR), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeOFB), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeRC4), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
	_ = CCCryptorCreateWithMode(CCOperation(kCCAlgorithmAES), CCMode(kCCModeCFB8), CCAlgorithm(kCCAlgorithm3DES), CCPadding(0), iv, key, keyLen, nil, 0, 0, CCModeOptions(0), &myCryptor)
}
