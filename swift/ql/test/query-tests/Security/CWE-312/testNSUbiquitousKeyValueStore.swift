
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

	store.set(password, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]
	store.set(passwordHash, forKey: "myKey") // GOOD (not sensitive)
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // BAD [NOT REPORTED]
	doSomething(password: x); // $ Source[swift/cleartext-storage-preferences]
	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]

	let y = getPassword(); // $ Source[swift/cleartext-storage-preferences]
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]

	let z = MyClass()
	NSUbiquitousKeyValueStore.default.set(z.harmless, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(z.password, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]
}

func test4(passwd: String) {
	// sanitizers...

	var x = passwd; // $ Source[swift/cleartext-storage-preferences]
	var y = passwd; // $ Source[swift/cleartext-storage-preferences]
	var z = passwd; // $ Source[swift/cleartext-storage-preferences]

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]
	NSUbiquitousKeyValueStore.default.set(z, forKey: "myKey") // $ Alert[swift/cleartext-storage-preferences]

	x = encrypt(x);
	hash(data: &y);
	z = "";

	NSUbiquitousKeyValueStore.default.set(x, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(y, forKey: "myKey") // GOOD (not sensitive)
	NSUbiquitousKeyValueStore.default.set(z, forKey: "myKey") // GOOD (not sensitive)
}
