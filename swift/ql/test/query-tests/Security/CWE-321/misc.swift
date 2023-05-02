
// --- stubs ---

class Data {
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

	_ = Realm.Configuration(encryptionKey: myVarKey) // GOOD
	_ = Realm.Configuration(encryptionKey: myConstKey) // BAD

	var config = Realm.Configuration() // GOOD
	config.encryptionKey = myVarKey // GOOD
	config.encryptionKey = myConstKey // BAD

	var configContainer = ConfigContainer()
	configContainer.config.encryptionKey = myVarKey // GOOD
	configContainer.config.encryptionKey = myConstKey // BAD
}
