
// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

class NSObject
{
}

struct _RNCryptorSettings {
	// ...
}
typealias RNCryptorSettings = _RNCryptorSettings

let kRNCryptorAES256Settings = RNCryptorSettings()

typealias RNCryptorHandler = () -> Void // simplified

class RNCryptor : NSObject
{
}

class RNEncryptor : RNCryptor
{
	override init() {}

	init(settings: RNCryptorSettings, encryptionKey: Data?, hmacKey HMACKey: Data?, handler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, encryptionKey: Data?, HMACKey: Data?, handler: RNCryptorHandler?) {}
	init(settings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, hmacKey anHMACKey: Data?, iv anIV: Data?, handler aHandler: RNCryptorHandler?) {}
	init(settings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, HMACKey anHMACKey: Data?, IV anIV: Data?, handler aHandler: RNCryptorHandler?) {}

	func encryptData(_ data: Data?, with settings: RNCryptorSettings, encryptionKey: Data?, hmacKey HMACKey: Data?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, withSettings settings: RNCryptorSettings, encryptionKey: Data?, HMACKey: Data?) throws -> Data { return Data(0) }
	func encryptData(_ thePlaintext: Data?, with theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, hmacKey anHMACKey: Data?, iv anIV: Data?) throws -> Data { return Data(0) }
	func encryptData(_ thePlaintext: Data?, withSettings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, HMACKey anHMACKey: Data?, IV anIV: Data?) throws -> Data { return Data(0) }
}

class RNDecryptor : RNCryptor
{
	override init() {}

	init(encryptionKey: Data?, hmacKey HMACKey: Data?, handler: RNCryptorHandler?) {}
	init(encryptionKey: Data?, HMACKey: Data?, handler: RNCryptorHandler?) {}

	func decryptData(_ data: Data?, withEncryptionKey encryptionKey: Data?, hmacKey HMACKey: Data?) throws -> Data { return Data(0) }
	func decryptData(_ data: Data?, withEncryptionKey encryptionKey: Data?, HMACKey: Data?) throws -> Data { return Data(0) }
	func decryptData(_ theCipherText: Data?, with settings: RNCryptorSettings, encryptionKey: Data?, hmacKey HMACKey: Data?) throws -> Data { return Data(0) }
	func decryptData(_ theCipherText: Data?, withSettings settings: RNCryptorSettings, encryptionKey: Data?, HMACKey: Data?) throws -> Data { return Data(0) }
}

// --- tests ---

func test(var myVarKey: Data, var myHMACKey: Data) {
	// RNCryptor
	let myEncryptor = RNEncryptor()
	let myDecryptor = RNDecryptor()
	let myData = Data(0)
	let myConstKey = Data("abcdef123456")
	let myHandler = {}
	let myIV = Data(0)

	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myVarKey, hmacKey: myHMACKey, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myConstKey, hmacKey: myHMACKey, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myConstKey, HMACKey: myHMACKey, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myConstKey, hmacKey: myHMACKey, iv: myIV, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myConstKey, HMACKey: myHMACKey, IV: myIV, handler: myHandler) // BAD

	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, encryptionKey: myConstKey, hmacKey: myHMACKey) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, encryptionKey: myConstKey, HMACKey: myHMACKey) // BAD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, encryptionKey: myConstKey, hmacKey: myHMACKey, iv: myIV) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, encryptionKey: myConstKey, HMACKey: myHMACKey, IV: myIV) // BAD

	let _ = RNDecryptor(encryptionKey: myConstKey, hmacKey: myHMACKey, handler: myHandler) // BAD
	let _ = RNDecryptor(encryptionKey: myConstKey, HMACKey: myHMACKey, handler: myHandler) // BAD

	let _ = try? myDecryptor.decryptData(myData, withEncryptionKey: myConstKey, hmacKey: myHMACKey) // BAD
	let _ = try? myDecryptor.decryptData(myData, withEncryptionKey: myConstKey, HMACKey: myHMACKey) // BAD
	let _ = try? myDecryptor.decryptData(myData, with: kRNCryptorAES256Settings, encryptionKey: myConstKey, hmacKey: myHMACKey) // BAD
	let _ = try? myDecryptor.decryptData(myData, withSettings: kRNCryptorAES256Settings, encryptionKey: myConstKey, HMACKey: myHMACKey) // BAD

	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myVarKey, hmacKey: myConstKey, handler: myHandler) // BAD
}
