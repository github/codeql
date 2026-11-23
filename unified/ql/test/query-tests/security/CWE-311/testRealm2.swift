//codeql-extractor-options: -module-name RealmSwift

// --- stubs ---

class Object {
}

// --- tests ---

class MyRealmSwiftObject3 : Object {
	override init() { data = "" }

	var data: String
}

func test1(o: MyRealmSwiftObject3, myHarmless: String, myPassword: String) {
	// ...
	o.data = myPassword // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = myHarmless
	// ...
}

func test2(o: MyRealmSwiftObject3, ccn: String, socialSecurityNumber: String, ssn: String, ssn_int: Int, userSSN: String, classno: String) {
	o.data = socialSecurityNumber // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = ssn // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = String(ssn_int) // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = userSSN // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = classno // GOOD
}

func test3(o: MyRealmSwiftObject3, ccn: String, creditCardNumber: String, CCN: String, int_ccn: Int, userCcn: String, succnode: String) {
	o.data = creditCardNumber // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = CCN // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = String(int_ccn) // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = userCcn // $ MISSING: Alert[unified/swift/cleartext-storage-database]
	o.data = succnode // GOOD
}
