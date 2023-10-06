
// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

class Database {
}

extension Database {
	func usePassphrase(_ passphrase: String) throws { }
	func usePassphrase(_ passphrase: Data) throws { }
	func changePassphrase(_ passphrase: String) throws { }
	func changePassphrase(_ passphrase: Data) throws { }
}

// --- tests ---

func test(db: Database, varString: String, varArray: Array<UInt8>, varData: Data) throws {
	let constString = "abc123"
	let constArray: Array<UInt8> = [1, 2, 3, 4, 5, 6]
	let constData = Data(constArray)

	// GRDB
	try db.usePassphrase(varString)
	try db.usePassphrase(constString) // BAD: constant key
	try db.usePassphrase(varData)
	try db.usePassphrase(constData) // BAD: constant key
	try db.changePassphrase(varString)
	try db.changePassphrase(constString) // BAD: constant key
	try db.changePassphrase(Data(varArray))
	try db.changePassphrase(constData) // BAD: constant key
}
