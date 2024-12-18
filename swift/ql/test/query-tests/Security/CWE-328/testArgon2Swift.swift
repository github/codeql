
// --- stubs ---

class Data
{
    init<S>(_ elements: S) {}
}

class Salt {
	init(bytes: Data) { }

    static func newSalt(length: Int = 16) -> Salt {
        return Salt(bytes: Data(0))
    }
}

class Argon2SwiftResult {
	init(hashBytes: [Int8], encodedBytes: [Int8]) { }

    func encodedString() -> String {
        return ""
    }
}

class Argon2Swift {
	// slightly simplified (type and version changed to Int)
	static func hashPasswordString(password: String, salt: Salt, iterations: Int = 32, memory: Int = 256, parallelism: Int = 2, length: Int = 32, type: Int = 1, version: Int = 13) throws -> Argon2SwiftResult {
		return Argon2SwiftResult(hashBytes: [], encodedBytes: [])
	}

	static func verifyHashString(password: String, hash: String, type: Int = 1) throws -> Bool {
		return false
	}
}

// --- tests ---

func testGoodExample(passwordString: String) {
    // this is the "good" example from the .qhelp
    let salt = Salt.newSalt()
    let result = try! Argon2Swift.hashPasswordString(password: passwordString, salt: salt) // GOOD (suitable password hash)
    let passwordHash = result.encodedString()

    // ...

    if try! Argon2Swift.verifyHashString(password: passwordString, hash: passwordHash) {
	    // ...
    }
}
