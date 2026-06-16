
// --- stubs ---

class NSObject
{
}

@propertyWrapper
struct NSManaged { // note: this may not be an accurate stub for `NSManaged`.
	var wrappedValue: Any {
		didSet {}
	}
}

class NSManagedObject : NSObject
{
}

class MyManagedObject2 : NSManagedObject
{
	@NSManaged public var myValue: Int
	@NSManaged public var myBankAccountNumber : Int
	public var notStoredBankAccountNumber: Int = 0
}

extension MyManagedObject2
{
	@NSManaged public var myBankAccountNumber2 : Int
}

// --- tests ---

func testCoreData2_1(obj: MyManagedObject2, maybeObj: MyManagedObject2?, value: Int, bankAccountNo: Int)
{
	// @NSManaged fields of an NSManagedObject...
	obj.myValue = value // GOOD (not sensitive)
	obj.myValue = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	obj.myBankAccountNumber = value // $ MISSING: Alert[swift/cleartext-storage-database] // BAD [NOT DETECTED]
	obj.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	obj.myBankAccountNumber2 = value // $ MISSING: Alert[swift/cleartext-storage-database] // BAD [NOT DETECTED]
	obj.myBankAccountNumber2 = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	obj.notStoredBankAccountNumber = value // GOOD (not stored in the database)
	obj.notStoredBankAccountNumber = bankAccountNo // $ SPURIOUS: Alert[swift/cleartext-storage-database] // GOOD (not stored in the database) [FALSE POSITIVE]

	maybeObj?.myValue = value // GOOD (not sensitive)
	maybeObj?.myValue = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	maybeObj?.myBankAccountNumber = value // $ MISSING: Alert[swift/cleartext-storage-database] // BAD [NOT DETECTED]
	maybeObj?.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	maybeObj?.myBankAccountNumber2 = value // $ MISSING: Alert[swift/cleartext-storage-database] // BAD [NOT DETECTED]
	maybeObj?.myBankAccountNumber2 = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	maybeObj?.notStoredBankAccountNumber = value // GOOD (not stored in the database)
	maybeObj?.notStoredBankAccountNumber = bankAccountNo // $ SPURIOUS: Alert[swift/cleartext-storage-database] // GOOD (not stored in the datbase) [FALSE POSITIVE]
}

class testCoreData2_2 {
	func myFunc(obj: MyManagedObject2, bankAccountNo: Int) {
		obj.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]

		if #available(iOS 10.0, *) {
			obj.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]
		} else {
			obj.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]
		}

		obj.myBankAccountNumber = bankAccountNo // $ Alert[swift/cleartext-storage-database]
	}
}

class MyContainer {
    var value: Int = 0
    var value2: Int! = 0
    var bankAccountNo: Int = 0
    var bankAccountNo2: Int! = 0
}

func testCoreData2_3(dbObj: MyManagedObject2, maybeObj: MyManagedObject2?, container: MyContainer, bankAccountNo: MyContainer, bankAccountNo2: MyContainer!) {
	dbObj.myValue = container.value // GOOD (not sensitive)
	dbObj.myValue = container.value2 // GOOD (not sensitive)
	dbObj.myValue = container.bankAccountNo // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = container.bankAccountNo2 // $ Alert[swift/cleartext-storage-database]

	dbObj.myValue = bankAccountNo.value // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = bankAccountNo.value2 // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = bankAccountNo2.value // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = bankAccountNo2.value2 // $ Alert[swift/cleartext-storage-database]

	maybeObj?.myValue = container.bankAccountNo // $ Alert[swift/cleartext-storage-database]
	maybeObj?.myValue = bankAccountNo.value // $ Alert[swift/cleartext-storage-database]
	maybeObj?.myValue = bankAccountNo2.value2 // $ Alert[swift/cleartext-storage-database]

	var a = bankAccountNo // $ Source[swift/cleartext-storage-database] // sensitive
	var b = a.value
	dbObj.myValue = b // $ Alert[swift/cleartext-storage-database]

	let c = bankAccountNo // $ Source[swift/cleartext-storage-database] // sensitive
	var d: MyContainer = MyContainer()
	d.value = c.value
	dbObj.myValue = d.value // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = d.value2 // GOOD

	let e = bankAccountNo // $ Source[swift/cleartext-storage-database] // sensitive
	var f: MyContainer?
	f?.value = e.value
	dbObj.myValue = e.value // $ Alert[swift/cleartext-storage-database]
	dbObj.myValue = e.value2 // $ SPURIOUS: Alert[swift/cleartext-storage-database] // GOOD [FALSE POSITIVE]
}
