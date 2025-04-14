
// --- stubs ---

struct Data {
    init<S>(_ elements: S) {}
}

struct URL {
    init(fileURLWithPath path: String, isDirectory: Bool) {}
}

class Realm {
}

extension Realm {
	struct Configuration {
		init(
			fileURL: URL? = URL(fileURLWithPath: "defaultFile", isDirectory: false),
			inMemoryIdentifier: String? = nil,
			syncConfiguration: Int = 0,
			encryptionKey: Data? = nil,
			readOnly: Bool = false,
			schemaVersion: UInt64 = 0,
			migrationBlock: Int = 0,
			deleteRealmIfMigrationNeeded: Bool = false,
			shouldCompactOnLaunch: Bool = false,
			objectTypes: Int = 0,
			seedFilePath: URL? = nil) { }

		var encryptionKey: Data?
	}
}

protocol BlockMode { }

struct CBC: BlockMode {
	init(iv: Array<UInt8>) { }
}

class AES
{
	init(key: Array<UInt8>, blockMode: BlockMode) { }
}

// --- tests ---

class ConfigContainer {
	init() {
		config = Realm.Configuration()
	}

	var config: Realm.Configuration
}

func test(myVarStr: String) {
	let myVarKey = Data(myVarStr)
	let myConstKey = Data("abcdef123456")

	// --- realm ---

	_ = Realm.Configuration(encryptionKey: myVarKey) // GOOD
	_ = Realm.Configuration(encryptionKey: myConstKey) // BAD

	var config = Realm.Configuration() // GOOD
	config.encryptionKey = myVarKey // GOOD
	config.encryptionKey = myConstKey // BAD

	var configContainer = ConfigContainer()
	configContainer.config.encryptionKey = myVarKey // GOOD
	configContainer.config.encryptionKey = myConstKey // BAD
}

func useKeys(_ k1: String, _ k2: String, _ k3: String, _ myIV: Array<UInt8>) {
	// --- cryptoswift ---

	let a1 = AES(key: Array(k1.utf8), blockMode: CBC(iv: myIV)) // BAD
	let a2 = AES(key: Array(k2.utf8), blockMode: CBC(iv: myIV)) // BAD
	let a3 = AES(key: Array(k3.utf8), blockMode: CBC(iv: myIV)) // GOOD
}

func caller(varString: String, myIV: Array<UInt8>) {
	useKeys("abc123", varString, varString, myIV)
	useKeys("abc123", "abc123", varString, myIV)
}
