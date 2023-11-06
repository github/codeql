//codeql-extractor-options: -module-name RealmSwift

// --- stubs ---

class Object {
}

// --- tests ---

class MyRealmSwiftObject3 : Object {
	override init() { data = "" }

	var data: String
}

func test1(o: MyRealmSwiftObject3, myHarmless: String, myPassword : String) {
	// ...
	o.data = myPassword // BAD
	o.data = myHarmless
	// ...
}
