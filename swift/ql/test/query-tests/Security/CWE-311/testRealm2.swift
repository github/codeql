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
	o.data = myPassword // $ Alert[swift/cleartext-storage-database]
	o.data = myHarmless
	// ...
}

func test2(o: MyRealmSwiftObject3, ccn: String, socialSecurityNumber: String, ssn: String, ssn_int: Int, userSSN: String, classno: String) {
	o.data = socialSecurityNumber // $ Alert[swift/cleartext-storage-database]
	o.data = ssn // $ Alert[swift/cleartext-storage-database]
	o.data = String(ssn_int) // $ Alert[swift/cleartext-storage-database]
	o.data = userSSN // BAD [NOT DETECTED]
	o.data = classno // GOOD
}

func test3(o: MyRealmSwiftObject3, ccn: String, creditCardNumber: String, CCN: String, int_ccn: Int, userCcn: String, succnode: String) {
	o.data = creditCardNumber // $ Alert[swift/cleartext-storage-database]
	o.data = CCN // $ Alert[swift/cleartext-storage-database]
	o.data = String(int_ccn) // $ Alert[swift/cleartext-storage-database]
	o.data = userCcn // BAD [NOT DETECTED]
	o.data = succnode // GOOD
}
