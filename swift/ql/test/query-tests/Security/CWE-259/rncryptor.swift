
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
	func key(forPassword password: String?, salt: Data?, settings keySettings: RNCryptorKeyDerivationSettings) -> Data? { return nil }
	func keyForPassword(_ password: String?, salt: Data?, settings keySettings: RNCryptorKeyDerivationSettings) -> Data? { return nil }
}

class RNEncryptor : RNCryptor
{
	override init() {}

	init(settings: RNCryptorSettings, password: String?, handler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, password: String, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, password: String, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}

	func encryptData(_ data: Data?, with settings: RNCryptorSettings, password: String?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, withSettings settings: RNCryptorSettings, password: String?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, with settings: RNCryptorSettings, password: String?, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, withSettings settings: RNCryptorSettings, password: String?, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
}

class RNDecryptor : RNCryptor
{
	override init() {}

	init(password: String?, handler: RNCryptorHandler?) {}

	func decryptData(_ data: Data?, withPassword password: String?) throws -> Data { return Data(0) }
	func decryptData(_ theCipherText: Data?, withSettings settings: RNCryptorSettings, password aPassword: String?) throws -> Data { return Data(0) }
}

// --- tests ---

func getARandomPassword() -> String {
	let charset = "abcdefghijklmnopqrstuvwxyz1234567890"
	return String("............".map{_ in charset.randomElement()!})
}

func test(cond: Bool) {
	let myEncryptor = RNEncryptor()
	let myDecryptor = RNDecryptor()
	let myData = Data(0)

	let myRandomPassword = getARandomPassword()
	let myConstPassword = "abc123"
	let myMaybePassword = cond ? myRandomPassword : myConstPassword

	// reasonable usage

	let a = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myRandomPassword) // GOOD
	let _ = try? myDecryptor.decryptData(a, withPassword: myRandomPassword) // GOOD

	let b = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myConstPassword) // BAD
	let _ = try? myDecryptor.decryptData(b, withPassword: myConstPassword) // BAD

	let c = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myMaybePassword) // BAD
	let _ = try? myDecryptor.decryptData(c, withPassword: myMaybePassword) // BAD

	// all methods

	let myKeyDerivationSettings = RNCryptorKeyDerivationSettings()
	let myHandler = {}
	let myIV = Data(0)
	let mySalt = Data(0)
	let mySalt2 = Data(0)

	let _ = myEncryptor.key(forPassword: myConstPassword, salt: mySalt, settings: myKeyDerivationSettings) // BAD
	let _ = myEncryptor.keyForPassword(myConstPassword, salt: mySalt, settings: myKeyDerivationSettings) // BAD
	let _ = myDecryptor.key(forPassword: myConstPassword, salt: mySalt, settings: myKeyDerivationSettings) // BAD
	let _ = myDecryptor.keyForPassword(myConstPassword, salt: mySalt, settings: myKeyDerivationSettings) // BAD

	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myConstPassword, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myConstPassword, iv: myIV, encryptionSalt: mySalt, hmacSalt: mySalt2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myConstPassword, IV: myIV, encryptionSalt: mySalt, HMACSalt: mySalt2, handler: myHandler) // BAD

	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myConstPassword) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myConstPassword) // BAD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myConstPassword, iv: myIV, encryptionSalt: mySalt, hmacSalt: mySalt2) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myConstPassword, IV: myIV, encryptionSalt: mySalt, HMACSalt: mySalt2) // BAD

	let _ = RNDecryptor(password: myConstPassword, handler: myHandler) // BAD

	let _ = try? myDecryptor.decryptData(myData, withPassword: myConstPassword) // BAD
	let _ = try? myDecryptor.decryptData(myData, withSettings: kRNCryptorAES256Settings, password: myConstPassword) // BAD
}
