
// --- stubs ---

class NSObject
{
}

class UserDefaults : NSObject
{
    class var standard: UserDefaults {
        return UserDefaults()
    }

	func set(_ value: Any?, forKey defaultName: String) {}
}

func encrypt(_ data: String) -> String { return data }
func hash(data: inout String) { }

func getPassword() -> String { return "" }
func doSomething(password: String) { }

// --- tests ---

func test1(password: String, passwordHash : String) {
	let defaults = UserDefaults.standard

	defaults.set(password, forKey: "myKey") // BAD
	defaults.set(passwordHash, forKey: "myKey") // GOOD (not sensitive)
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func test3(x: String) {
	// alternative evidence of sensitivity...

	UserDefaults.standard.set(x, forKey: "myKey") // BAD [NOT REPORTED]
	doSomething(password: x);
	UserDefaults.standard.set(x, forKey: "myKey") // BAD

	let y = getPassword();
	UserDefaults.standard.set(y, forKey: "myKey") // BAD

	let z = MyClass()
	UserDefaults.standard.set(z.harmless, forKey: "myKey") // GOOD (not sensitive)
	UserDefaults.standard.set(z.password, forKey: "myKey") // BAD
}

func test4(passwd: String) {
	// sanitizers...

	var x = passwd;
	var y = passwd;
	var z = passwd;

	UserDefaults.standard.set(x, forKey: "myKey") // BAD
	UserDefaults.standard.set(y, forKey: "myKey") // BAD
	UserDefaults.standard.set(z, forKey: "myKey") // BAD

	x = encrypt(x);
	hash(data: &y);
	z = "";

	UserDefaults.standard.set(x, forKey: "myKey") // GOOD (not sensitive)
	UserDefaults.standard.set(y, forKey: "myKey") // GOOD (not sensitive)
	UserDefaults.standard.set(z, forKey: "myKey") // GOOD (not sensitive)
}

struct MyOuter {
	struct MyInner {
		var value: String
	}

	var password: MyInner
	var harmless: MyInner
}

func test5(mo : MyOuter) {
	UserDefaults.standard.set(mo.password.value, forKey: "myKey") // BAD
	UserDefaults.standard.set(mo.harmless.value, forKey: "myKey") // GOOD
}
