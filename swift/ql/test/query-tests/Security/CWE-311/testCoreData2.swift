
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
	obj.myValue = bankAccountNo // BAD
	obj.myBankAccountNumber = value // BAD [NOT DETECTED]
	obj.myBankAccountNumber = bankAccountNo // BAD
	obj.myBankAccountNumber2 = value // BAD [NOT DETECTED]
	obj.myBankAccountNumber2 = bankAccountNo // BAD
	obj.notStoredBankAccountNumber = value // GOOD (not stored in the database)
	obj.notStoredBankAccountNumber = bankAccountNo // GOOD (not stored in the datbase) [FALSE POSITIVE]

	maybeObj?.myValue = value // GOOD (not sensitive)
	maybeObj?.myValue = bankAccountNo // BAD
	maybeObj?.myBankAccountNumber = value // BAD [NOT DETECTED]
	maybeObj?.myBankAccountNumber = bankAccountNo // BAD
	maybeObj?.myBankAccountNumber2 = value // BAD [NOT DETECTED]
	maybeObj?.myBankAccountNumber2 = bankAccountNo // BAD
	maybeObj?.notStoredBankAccountNumber = value // GOOD (not stored in the database)
	maybeObj?.notStoredBankAccountNumber = bankAccountNo // GOOD (not stored in the datbase) [FALSE POSITIVE]
}

class testCoreData2_2 {
	func myFunc(obj: MyManagedObject2, bankAccountNo: Int) {
		obj.myBankAccountNumber = bankAccountNo // BAD

		if #available(iOS 10.0, *) {
			obj.myBankAccountNumber = bankAccountNo // BAD
		} else {
			obj.myBankAccountNumber = bankAccountNo // BAD
		}

		obj.myBankAccountNumber = bankAccountNo // BAD
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
	dbObj.myValue = container.bankAccountNo // BAD
	dbObj.myValue = container.bankAccountNo2 // BAD

	dbObj.myValue = bankAccountNo.value // BAD [NOT DETECTED]
	dbObj.myValue = bankAccountNo.value2 // BAD [NOT DETECTED]
	dbObj.myValue = bankAccountNo2.value // BAD [NOT DETECTED]
	dbObj.myValue = bankAccountNo2.value2 // BAD [NOT DETECTED]

	maybeObj?.myValue = container.bankAccountNo // BAD
	maybeObj?.myValue = bankAccountNo.value // BAD [NOT DETECTED]
	maybeObj?.myValue = bankAccountNo2.value2 // BAD [NOT DETECTED]

	var a = bankAccountNo // sensitive
	var b = a.value
	dbObj.myValue = b // BAD [NOT DETECTED]
}
