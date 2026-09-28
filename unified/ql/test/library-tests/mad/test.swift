func test(url: URL, string: String) {
    String(url)  // not a source

    String(contentsOf: url)  // $ isSource=remote
    String(contentsOf: url, encoding: .utf8)  // $ isSource=remote
    String(contentsOf: url, usedEncoding: .utf8)  // $ isSource=remote
    String.init(contentsOf: url)  // $ isSource=remote

    String(contentsOfFile: string)  // $ isSource=local isSink=path-injection
    String(
        contentsOfFile: string,  // $ isSink=path-injection
        encoding: .utf8)  // $ isSource=local
    String(
        contentsOfFile: string,  // $ isSink=path-injection
        usedEncoding: .utf8)  // $ isSource=local

    FileManager.default.createDirectory(
        atPath: string,  // $ isSink=path-injection
        withIntermediateDirectories: true, attributes: nil)

    string.md5()  // $ isSink=weak-hash-input-MD5

    _ = try! Regex(string)  // $ isSink=regex-use
    _ = try! Regex(string, as: Substring.self)  // $ isSink=regex-use

    class TestTextInput: UITextInput {
        func shouldChangeText(
            in range: UITextRange,
            replacementText text: String  // $ isSource=local // parameters not detected yet
        ) -> Bool {
            return true
        }
    }
}

class UITextField {
    var text: String = ""
}

class URLSessionConfiguration {
    var tlsMaximumSupportedProtocol: Int = 0
    var tlsMinimumSupportedProtocol: Int = 0
    var tlsMaximumSupportedProtocolVersion: Int = 0
    var tlsMinimumSupportedProtocolVersion: Int = 0
}

func testProperties(
    string: String,
    textField: UITextField,
    configuration: URLSessionConfiguration
) {
    _ = string.count  // $ MISSING: isSource=string-length
    _ = textField.text  // $ MISSING: isSource=local

    configuration.tlsMaximumSupportedProtocol = 0  // $ MISSING: isSink=tls-protocol-version
    configuration.tlsMinimumSupportedProtocol = 0  // $ MISSING: isSink=tls-protocol-version
    configuration.tlsMaximumSupportedProtocolVersion = 0  // $ MISSING: isSink=tls-protocol-version
    configuration.tlsMinimumSupportedProtocolVersion = 0  // $ MISSING: isSink=tls-protocol-version
}

class Realm {
    struct Configuration {}
}

func testQualifiedConstructors(
    encodedOffset: Int,
    encryptionKey: String,
    fileURL: String,
    seedFilePath: String
) {
    _ = String.Index(encodedOffset: encodedOffset)  // $ isSink=string-length
    _ = String.Index.init(encodedOffset: encodedOffset)  // $ isSink=string-length

    _ = Realm.Configuration(
        deleteRealmIfMigrationNeeded: false,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        migrationBlock: nil,
        objectTypes: nil,
        readOnly: false,
        schemaVersion: 0,
        shouldCompactOnLaunch: nil,
        syncConfiguration: nil)

    _ = Realm.Configuration.init(
        deleteRealmIfMigrationNeeded: false,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        migrationBlock: nil,
        objectTypes: nil,
        readOnly: false,
        schemaVersion: 0,
        shouldCompactOnLaunch: nil,
        syncConfiguration: nil)

    _ = Realm.Configuration(
        deleteRealmIfMigrationNeeded: false,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        migrationBlock: nil,
        objectTypes: nil,
        readOnly: false,
        schemaVersion: 0,
        seedFilePath: seedFilePath,  // $ isSink=path-injection
        shouldCompactOnLaunch: nil,
        syncConfiguration: nil)
}
