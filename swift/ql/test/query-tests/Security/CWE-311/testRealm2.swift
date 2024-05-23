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
	o.data = myPassword // BAD
	o.data = myHarmless
	// ...
}

func test2(o: MyRealmSwiftObject3, ccn: String, socialSecurityNumber: String, ssn: String, ssn_int: Int, userSSN: String, classno: String) {
	o.data = socialSecurityNumber // BAD
	o.data = ssn // BAD [NOT DETECTED]
	o.data = String(ssn_int) // BAD [NOT DETECTED]
	o.data = userSSN // BAD [NOT DETECTED]
	o.data = classno // GOOD
}

func test3(o: MyRealmSwiftObject3, ccn: String, creditCardNumber: String, CCN: String, int_ccn: Int, userCcn: String, succnode: String) {
	o.data = creditCardNumber // BAD
	o.data = CCN // BAD [NOT DETECTED]
	o.data = String(int_ccn) // BAD [NOT DETECTED]
	o.data = userCcn // BAD [NOT DETECTED]
	o.data = succnode // GOOD
}
