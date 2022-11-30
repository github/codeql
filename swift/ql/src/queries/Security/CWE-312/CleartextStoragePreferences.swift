
func storeMyData(faveSong : String, creditCardNo : String) {
	// ...

	// GOOD: not sensitive information
	UserDefaults.standard.set(faveSong, forKey: "myFaveSong")

	// BAD: sensitive information saved in cleartext
	UserDefaults.standard.set(creditCardNo, forKey: "myCreditCardNo")

	// GOOD: encrypted sensitive information saved
	UserDefaults.standard.set(encrypt(creditCardNo), forKey: "myCreditCardNo")

	// ...
}
