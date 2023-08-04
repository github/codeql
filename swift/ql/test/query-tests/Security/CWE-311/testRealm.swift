
// --- stubs ---

enum UpdatePolicy : Int {
	case error = 1
}

class RealmSwiftObject {
}

typealias Object = RealmSwiftObject

class Realm {
	func add(_ object: Object, update: UpdatePolicy = .error) {}

	func create<T>(_ type : T.Type, value: Any = [:], update: UpdatePolicy = .error) where T : RealmSwiftObject { }

	func object<Element, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? where Element : RealmSwiftObject { return nil }

}

// --- tests ---

class MyRealmSwiftObject : RealmSwiftObject {
	override init() { data = "" }

	var data: String
}

class MyRealmSwiftObject2 : Object {
	override init() { password = "" }

	var harmless: String?
	var password: String?
}

func test1(realm : Realm, myHarmless: String, myPassword : String, myHashedPassword : String) {
	// add objects (within a transaction) ...

	let a = MyRealmSwiftObject()
	a.data = myPassword // BAD
	realm.add(a)

	let b = MyRealmSwiftObject()
	b.data = myHashedPassword
	realm.add(b) // GOOD (not sensitive)

	let c = MyRealmSwiftObject()
	c.data = myPassword // BAD
	realm.create(MyRealmSwiftObject.self, value: c)

	let d = MyRealmSwiftObject()
	d.data = myHashedPassword
	realm.create(MyRealmSwiftObject.self, value: d) // GOOD (not sensitive)

	// retrieve objects ...

	var e = realm.object(ofType: MyRealmSwiftObject.self, forPrimaryKey: "key")
	e!.data = myPassword // BAD

	var f = realm.object(ofType: MyRealmSwiftObject.self, forPrimaryKey: "key")
	f!.data = myHashedPassword // GOOD (not sensitive)

	let g = MyRealmSwiftObject()
	g.data = "" // GOOD (not sensitive)
	g.data = myPassword // BAD
	g.data = "" // GOOD (not sensitive)

	// MyRealmSwiftObject2...

	let h = MyRealmSwiftObject2()
	h.harmless = myHarmless // GOOD (not sensitive)
	h.password = myPassword // BAD
	realm.add(h)
}

// limitation: its possible to configure a Realm DB to be stored encrypted, if this is done correctly
// (taking care with the encryption key) then storing otherwise plaintext sensitive data would be OK.
