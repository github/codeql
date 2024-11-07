import CryptoKit

private func encrypt(_ text: String, _ encryptionKey: SymmetricKey) -> String {
	let sealedBox = try! AES.GCM.seal(Data(text.utf8), using: encryptionKey)
	return sealedBox.combined!.base64EncodedString()
}

func storeMyData(databaseObject : NSManagedObject, faveSong : String, creditCardNo : String, encryptionKey: SymmetricKey) {
	// ...

	// GOOD: not sensitive information
	databaseObject.setValue(faveSong, forKey: "myFaveSong")

	// BAD: sensitive information saved in cleartext
	databaseObject.setValue(creditCardNo, forKey: "myCreditCardNo")

	// GOOD: encrypted sensitive information saved
	databaseObject.setValue(encrypt(creditCardNo, encryptionKey), forKey: "myCreditCardNo")

	// ...
}
