
func storeMyData(databaseObject : NSManagedObject, faveSong : String, creditCardNo : String) {
	// ...

	// GOOD: not sensitive information
	databaseObject.setValue(faveSong, forKey: "myFaveSong")

	// BAD: sensitive information saved in cleartext
	databaseObject.setValue(creditCardNo, forKey: "myCreditCardNo")

	// GOOD: encrypted sensitive information saved
	databaseObject.setValue(encrypt(creditCardNo), forKey: "myCreditCardNo")

	// ...
}
