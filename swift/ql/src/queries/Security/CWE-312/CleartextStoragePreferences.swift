import CryptoKit

private func encrypt(_ text: String, _ encryptionKey: SymmetricKey) -> String {
	let sealedBox = try! AES.GCM.seal(Data(text.utf8), using: encryptionKey)
	return sealedBox.combined!.base64EncodedString()
}

func storeMyData(faveSong : String, creditCardNo : String, encryptionKey: SymmetricKey) {
	// ...

	// GOOD: not sensitive information
	UserDefaults.standard.set(faveSong, forKey: "myFaveSong")

	// BAD: sensitive information saved in cleartext
	UserDefaults.standard.set(creditCardNo, forKey: "myCreditCardNo")

	// GOOD: encrypted sensitive information saved
	UserDefaults.standard.set(encrypt(creditCardNo, encryptionKey), forKey: "myCreditCardNo")

	// ...
}
