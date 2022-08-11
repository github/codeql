
// --- stubs ---

class NSObject
{
}

class NSManagedObject : NSObject
{
	func value(forKey: String) -> Any? { return "" }
	func setValue(_: Any?, forKey: String) {}
	func primitiveValue(forKey: String) -> Any? { return "" }
	func setPrimitiveValue(_: Any?, forKey: String) {}
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
			setValue(newValue, forKey: "myKey")
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

	obj.setIndirect(value: password) // BAD
	obj.setIndirect(value: password_file) // GOOD (not sensitive)

	obj.myValue = password // BAD
	obj.myValue = password_file // GOOD (not sensitive)
}

func test3(obj : NSManagedObject, x : String) {
	// alternative evidence of sensitivity...

	obj.setValue(x, forKey: "myKey") // BAD
	doSomething(password: x);
	obj.setValue(x, forKey: "myKey") // BAD

	var y = getPassword();
	obj.setValue(y, forKey: "myKey") // BAD
}

func test4(obj : NSManagedObject, pwd : String) {
	// sanitizers...

	var x = pwd;
	var y = pwd;
	var z = pwd;

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
