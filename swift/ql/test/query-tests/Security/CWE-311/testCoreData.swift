
// --- stubs ---

class NSObject
{
}

class NSManagedObject : NSObject
{
	func value(forKey key: String) -> Any? { return "" }
	func setValue(_ value: Any?, forKey key: String) {}
	func primitiveValue(forKey key: String) -> Any? { return "" }
	func setPrimitiveValue(_ value: Any?, forKey key: String) {}
}

class MyManagedObject : NSManagedObject
{
	func setIndirect(value: String) {
		setValue(value, forKey: "myKey")
	}

	var myValue: String {
		get {
			if let v = value(forKey: "myKey") as? String
			{
				return v
			} else {
				return ""
			}
		}
		set {
			setValue(newValue, forKey: "myKey") // [additional result reported here]
		}
	}
}

func encrypt(_ data: String) -> String { return data }
func hash(data: inout String) { }

func getPassword() -> String { return "" }
func doSomething(password: String) { }

// --- tests ---

func test1(obj : NSManagedObject, password : String, password_hash : String) {
	// NSManagedObject methods...

	obj.setValue(password, forKey: "myKey") // BAD
	obj.setValue(password_hash, forKey: "myKey") // GOOD (not sensitive)

	obj.setPrimitiveValue(password, forKey: "myKey") // BAD
	obj.setPrimitiveValue(password_hash, forKey: "myKey") // GOOD (not sensitive)
}

func test2(obj : MyManagedObject, password : String, password_file : String) {
	// MyManagedObject methods...

	obj.setValue(password, forKey: "myKey") // BAD
	obj.setValue(password_file, forKey: "myKey") // GOOD (not sensitive)

	obj.setIndirect(value: password) // BAD [reported on line 19]
	obj.setIndirect(value: password_file) // GOOD (not sensitive)

	obj.myValue = password // BAD [also reported on line 32]
	obj.myValue = password_file // GOOD (not sensitive)
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func test3(obj : NSManagedObject, x : String) {
	// alternative evidence of sensitivity...

	obj.setValue(x, forKey: "myKey") // BAD [NOT REPORTED]
	doSomething(password: x);
	obj.setValue(x, forKey: "myKey") // BAD

	let y = getPassword();
	obj.setValue(y, forKey: "myKey") // BAD

	let z = MyClass()
	obj.setValue(z.harmless, forKey: "myKey") // GOOD (not sensitive)
	obj.setValue(z.password, forKey: "myKey") // BAD
}

func test4(obj : NSManagedObject, passwd : String) {
	// sanitizers...

	var x = passwd;
	var y = passwd;
	var z = passwd;

	obj.setValue(x, forKey: "myKey") // BAD
	obj.setValue(y, forKey: "myKey") // BAD
	obj.setValue(z, forKey: "myKey") // BAD

	x = encrypt(x);
	hash(data: &y);
	z = "";

	obj.setValue(x, forKey: "myKey") // GOOD (not sensitive)
	obj.setValue(y, forKey: "myKey") // GOOD (not sensitive)
	obj.setValue(z, forKey: "myKey") // GOOD (not sensitive)
}

func createSecureKey() -> String { return "" }
func generateSecretKey() -> String { return "" }
func getCertificate() -> String { return "" }

class KeyGen {
	func generate() -> String { return "" }
}

class KeyManager {
	func generateKey() -> String { return "" }
}

class SecureKeyStore {
	func getEncryptionKey() -> String { return "" }
}

func test5(obj : NSManagedObject) {
	// more variants...

	obj.setValue(createSecureKey(), forKey: "myKey") // BAD [NOT DETECTED]
	obj.setValue(generateSecretKey(), forKey: "myKey") // BAD
	obj.setValue(getCertificate(), forKey: "myKey") // BAD

	let gen = KeyGen()
	let v = gen.generate()

	obj.setValue(KeyGen().generate(), forKey: "myKey") // BAD [NOT DETECTED]
	obj.setValue(gen.generate(), forKey: "myKey") // BAD [NOT DETECTED]
	obj.setValue(v, forKey: "myKey") // BAD [NOT DETECTED]
	obj.setValue(KeyManager().generateKey(), forKey: "myKey") // BAD [NOT DETECTED]
	obj.setValue(SecureKeyStore().getEncryptionKey(), forKey: "myKey") // BAD [NOT DETECTED]
}
