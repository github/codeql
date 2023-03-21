
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

struct _RNCryptorKeyDerivationSettings {
	// ...
}
typealias RNCryptorKeyDerivationSettings = _RNCryptorKeyDerivationSettings

typealias RNCryptorHandler = () -> Void // simplified

class RNCryptor : NSObject
{
}

class RNEncryptor : RNCryptor
{
	override init() {}

	init(settings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, hmacKey anHMACKey: Data?, iv anIV: Data?, handler aHandler: RNCryptorHandler?) {}
	init(settings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, HMACKey anHMACKey: Data?, IV anIV: Data?, handler aHandler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, password: String, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, password: String, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}

	func encryptData(_ thePlaintext: Data?, with theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, hmacKey anHMACKey: Data?, iv anIV: Data?) throws -> Data { return Data(0) }
	func encryptData(_ thePlaintext: Data?, withSettings theSettings: RNCryptorSettings, encryptionKey anEncryptionKey: Data?, HMACKey anHMACKey: Data?, IV anIV: Data?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, with settings: RNCryptorSettings, password: String?, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, withSettings settings: RNCryptorSettings, password: String?, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
}

// --- tests ---

func getRandomArray() -> [UInt8] {
	(0..<12).map({ _ in UInt8.random(in: 0...UInt8.max) })
}

func test(myPassword: String) {
	// RNCryptor
	let myEncryptor = RNEncryptor()
	let myData = Data(0)
	let myKey = Data(0)
	let myHMACKey = Data(0)
	let myKeyDerivationSettings = RNCryptorKeyDerivationSettings()
	let myHandler = {}
	let myRandomIV = Data(getRandomArray())
	let myConstIV1 = Data(0)
	let myConstIV2 = Data(123)
	let myConstIV3 = Data([1,2,3,4,5])
	let myConstIV4 = Data("iv")
	let mySalt = Data(0)
	let mySalt2 = Data(0)

	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myKey, hmacKey: myHMACKey, iv: myRandomIV, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myKey, hmacKey: myHMACKey, iv: myConstIV1, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myKey, HMACKey: myHMACKey, IV: myRandomIV, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, encryptionKey: myKey, HMACKey: myHMACKey, IV: myConstIV2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, iv: myRandomIV, encryptionSalt: mySalt, hmacSalt: mySalt2, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, iv: myConstIV3, encryptionSalt: mySalt, hmacSalt: mySalt2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, IV: myRandomIV, encryptionSalt: mySalt, HMACSalt: mySalt2, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, IV: myConstIV4, encryptionSalt: mySalt, HMACSalt: mySalt2, handler: myHandler) // BAD

	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, encryptionKey: myKey, hmacKey: myHMACKey, iv: myRandomIV) // GOOD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, encryptionKey: myKey, hmacKey: myHMACKey, iv: myConstIV1) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, encryptionKey: myKey, HMACKey: myHMACKey, IV: myRandomIV) // GOOD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, encryptionKey: myKey, HMACKey: myHMACKey, IV: myConstIV2) // BAD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myPassword, iv: myRandomIV, encryptionSalt: mySalt, hmacSalt: mySalt2) // GOOD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myPassword, iv: myConstIV3, encryptionSalt: mySalt, hmacSalt: mySalt2) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myPassword, IV: myRandomIV, encryptionSalt: mySalt, HMACSalt: mySalt2) // GOOD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myPassword, IV: myConstIV4, encryptionSalt: mySalt, HMACSalt: mySalt2) // BAD
}
