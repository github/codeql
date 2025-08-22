import CryptoKit

private func encrypt(_ text: String, _ encryptionKey: SymmetricKey) -> String {
	let sealedBox = try! AES.GCM.seal(Data(text.utf8), using: encryptionKey)
	return sealedBox.combined!.base64EncodedString()
}

func transmitMyData(connection : NWConnection, faveSong : String, creditCardNo : String, encryptionKey: SymmetricKey) {
	// ...

	// GOOD: not sensitive information
	connection.send(content: faveSong, completion: .idempotent)

	// BAD: sensitive information saved in cleartext
	connection.send(content: creditCardNo, completion: .idempotent)

	// GOOD: encrypted sensitive information saved
	connection.send(content: encrypt(creditCardNo, encryptionKey), completion: .idempotent)

	// ...
}
