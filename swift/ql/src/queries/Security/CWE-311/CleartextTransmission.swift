
func transmitMyData(connection : NWConnection, faveSong : String, creditCardNo : String) {
	// ...

	// GOOD: not sensitive information
	connection.send(content: faveSong, completion: .idempotent)

	// BAD: sensitive information saved in cleartext
	connection.send(content: creditCardNo, completion: .idempotent)

	// GOOD: encrypted sensitive information saved
	connection.send(content: encrypt(creditCardNo), completion: .idempotent)

	// ...
}
