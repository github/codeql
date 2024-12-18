
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

	init(settings: RNCryptorSettings, password: String, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}
	init(settings: RNCryptorSettings, password: String, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?, handler: RNCryptorHandler?) {}

	func encryptData(_ data: Data?, with settings: RNCryptorSettings, password: String?, iv anIV: Data?, encryptionSalt anEncryptionSalt: Data?, hmacSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
	func encryptData(_ data: Data?, withSettings settings: RNCryptorSettings, password: String?, IV anIV: Data?, encryptionSalt anEncryptionSalt: Data?, HMACSalt anHMACSalt: Data?) throws -> Data { return Data(0) }
}

// --- tests ---

func getARandomString() -> String {
	let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	return String("................".map{_ in charset.randomElement()!})
}

func test(myPassword: String) {
	// RNCryptor
	let myEncryptor = RNEncryptor()
	let myData = Data(0)
	let myKeyDerivationSettings = RNCryptorKeyDerivationSettings()
	let myHandler = {}
	let myIV = Data(0)
	let myRandomSalt1 = Data(getARandomString())
	let myRandomSalt2 = Data(getARandomString())
	let myConstantSalt1 = Data("abcdef123456")
	let myConstantSalt2 = Data(0)

	let _ = myEncryptor.key(forPassword: myPassword, salt: myRandomSalt1, settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.key(forPassword: myPassword, salt: myConstantSalt1, settings: myKeyDerivationSettings) // BAD
	let _ = myEncryptor.keyForPassword(myPassword, salt: myRandomSalt2, settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.keyForPassword(myPassword, salt: myConstantSalt2, settings: myKeyDerivationSettings) // BAD

	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myRandomSalt1, hmacSalt: myRandomSalt2, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myConstantSalt1, hmacSalt: myRandomSalt2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myRandomSalt1, hmacSalt: myConstantSalt2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myRandomSalt1, HMACSalt: myRandomSalt2, handler: myHandler) // GOOD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myConstantSalt1, HMACSalt: myRandomSalt2, handler: myHandler) // BAD
	let _ = RNEncryptor(settings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myRandomSalt1, HMACSalt: myConstantSalt2, handler: myHandler) // BAD

	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myRandomSalt1, hmacSalt: myRandomSalt2) // GOOD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myConstantSalt1, hmacSalt: myRandomSalt2) // BAD
	let _ = try? myEncryptor.encryptData(myData, with: kRNCryptorAES256Settings, password: myPassword, iv: myIV, encryptionSalt: myRandomSalt1, hmacSalt: myConstantSalt2) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myRandomSalt1, HMACSalt: myRandomSalt2) // GOOD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myConstantSalt1, HMACSalt: myRandomSalt2) // BAD
	let _ = try? myEncryptor.encryptData(myData, withSettings: kRNCryptorAES256Settings, password: myPassword, IV: myIV, encryptionSalt: myRandomSalt1, HMACSalt: myConstantSalt2) // BAD

	// appending constants
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(getARandomString() + getARandomString()), settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data("123" + getARandomString()), settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(getARandomString() + "abc"), settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data("123" + "abc"), settings: myKeyDerivationSettings) // BAD (constant salt) [NOT DETECTED]
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data("123\(getARandomString())abc"), settings: myKeyDerivationSettings) // GOOD
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data("123\("const"))abc"), settings: myKeyDerivationSettings) // BAD (constant salt) [NOT DETECTED]

	var myMutableString1 = "123"
	myMutableString1.append(getARandomString())
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(myMutableString1), settings: myKeyDerivationSettings) // GOOD

	var myMutableString2 = getARandomString()
	myMutableString2.append("abc")
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(myMutableString2), settings: myKeyDerivationSettings) // GOOD

	var myMutableString3 = "123"
	myMutableString3 += getARandomString()
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(myMutableString3), settings: myKeyDerivationSettings) // GOOD

	var myMutableString4 = getARandomString()
	myMutableString4 += "abc"
	let _ = myEncryptor.key(forPassword: myPassword, salt: Data(myMutableString4), settings: myKeyDerivationSettings) // GOOD
}
