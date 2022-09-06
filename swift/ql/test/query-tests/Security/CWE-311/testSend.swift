
// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

class NWConnection {
	enum SendCompletion {
		case idempotent
	}

	class ContentContext {
        static let defaultMessage = ContentContext()
    }
	
	func send(content: Data?, contentContext: NWConnection.ContentContext = .defaultMessage, isComplete: Bool = true, completion: NWConnection.SendCompletion) { }
	func send<Content>(content: Content?, contentContext: NWConnection.ContentContext = .defaultMessage, isComplete: Bool = true, completion: NWConnection.SendCompletion) { }
}

// --- tests ---

func test1(passwordPlain : String, passwordHash : String) {
	let nw = NWConnection()

	// ...

	nw.send(content: "123456", completion: .idempotent) // GOOD (not sensitive)
	nw.send(content: passwordPlain, completion: .idempotent) // BAD
	nw.send(content: passwordHash, completion: .idempotent) // GOOD (not sensitive)

	let data1 = Data("123456")
	let data2 = Data(passwordPlain)
	let data3 = Data(passwordHash)

	nw.send(content: data1, completion: .idempotent) // GOOD (not sensitive)
	nw.send(content: data2, completion: .idempotent) // BAD [NOT DETECTED]
	nw.send(content: data3, completion: .idempotent) // GOOD (not sensitive)
}

func pad(_ data: String) -> String { return data }
func aes_crypt(_ data: String) -> String { return data }

func test2(password : String, connection : NWConnection) {
	let str1 = password
	let str2 = password + " "
	let str3 = pad(password)
	let str4 = aes_crypt(password)
	let str5 = pad(aes_crypt(password))
	let str6 = aes_crypt(pad(password))

	connection.send(content: str1, completion: .idempotent) // BAD
	connection.send(content: str2, completion: .idempotent) // BAD
	connection.send(content: str3, completion: .idempotent) // BAD
	connection.send(content: str4, completion: .idempotent) // GOOD (encrypted)
	connection.send(content: str5, completion: .idempotent) // GOOD (encrypted)
	connection.send(content: str6, completion: .idempotent) // GOOD (encrypted)
}
