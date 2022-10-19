
// --- stubs ---

class NSObject
{
}

class NSUbiquitousKeyValueStore : NSObject
{
    class var `default`: NSUbiquitousKeyValueStore {
        return NSUbiquitousKeyValueStore()
    }

	func set(_ anObject: Any?, forKey aKey: String) {}
}

func encrypt(_ data: String) -> String { return data }
func hash(data: inout String) { }

func getPassword() -> String { return "" }
func doSomething(password: String) { }

// --- tests ---

func test1(password: String, passwordHash : String) {
	let store = NSUbiquitousKeyValueStore.default

	store.set(password, forKey: "myKey") // BAD
	store.set(passwordHash, forKey: "myKey") // GOOD (not sensitive)
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // BAD [NOT REPORTED]
	doSomething(password: x);
	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // BAD

	let y = getPassword();
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // BAD

	let z = MyClass()
	NSUbiquitousKeyValueStore.default.set(z.harmless, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(z.password, forKey: "myKey") // BAD
}

func test4(passwd: String) {
	// sanitizers...

	var x = passwd;
	var y = passwd;
	var z = passwd;

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // BAD
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // BAD
	NSUbiquitousKeyValueStore.default.set(z, forKey: "myKey") // BAD

	x = encrypt(x);
	hash(data: &y);
	z = "";

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(z, forKey: "myKey") // GOOD (not sensitive)
}
