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
    _ = string.count  // $ isSource=string-length
    _ = textField.text  // $ isSource=local

    configuration.tlsMaximumSupportedProtocol = 0  // $ isSink=tls-protocol-version
    configuration.tlsMinimumSupportedProtocol = 0  // $ isSink=tls-protocol-version
    configuration.tlsMaximumSupportedProtocolVersion = 0  // $ isSink=tls-protocol-version
    configuration.tlsMinimumSupportedProtocolVersion = 0  // $ isSink=tls-protocol-version

    _ = configuration.tlsMaximumSupportedProtocol  // reading a sink property is not a sink
    textField.text = ""  // writing a source property is not a source
}

class MyTextField: UITextField {}

class NotATextField {
    var text: String = ""
    var arguments: [String] = []
}

class Process {
    var arguments: [String] = []
    var launchPath: String = ""
}

class MyProcess: Process {}

class MyURLSessionConfiguration: URLSessionConfiguration {}

func testMoreProperties(
    myTextField: MyTextField,
    notATextField: NotATextField,
    unknown: UnknownType,
    process: Process,
    myProcess: MyProcess,
    myConfiguration: MyURLSessionConfiguration,
    string: String
) {
    _ = myTextField.text  // $ isSource=local
    _ = notATextField.text  // not a source: unrelated type
    _ = unknown.text  // not a source: unknown type

    process.launchPath = string  // $ isSink=command-injection
    process.arguments = [string]  // $ isSink=command-injection
    process.arguments.append(string)  // $ isSink=command-injection
    myProcess.arguments = [string]  // $ isSink=command-injection
    notATextField.arguments = [string]  // not a sink: unrelated type

    // `tlsMaximumSupportedProtocol` is modeled with subtypes=false
    myConfiguration.tlsMaximumSupportedProtocol = 0
}

class Realm {
    struct Configuration {
        var encryptionKey: String = ""
    }
}

func testNestedTypeProperty(configuration: Realm.Configuration, key: String) {
    var c1 = Realm.Configuration()
    c1.encryptionKey = key  // $ MISSING: isSink=encryption-key // nested types are not yet resolved by type inference

    var c2 = configuration
    c2.encryptionKey = key  // $ MISSING: isSink=encryption-key // nested types are not yet resolved by type inference
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

class Connection {
    enum Location {
        static func uri(_ path: String, parameters: String) {}
    }
}

func testConnectionLocation(string: String) {
    Connection.Location.uri(string, parameters: "")  // $ isSink=path-injection
}

extension UITextField {
    func testImplicitSelfSource() {
        _ = text  // $ isSource=local
        _ = self.text  // $ isSource=local
    }
}

extension Process {
    func testImplicitSelfSink(string: String) {
        launchPath = string  // $ isSink=command-injection
        arguments = [string]  // $ isSink=command-injection
        arguments.append(string)  // $ isSink=command-injection
    }
}

class MyProcess2: Process {
    func testImplicitSelfSinkInSubclass(string: String) {
        launchPath = string  // $ isSink=command-injection
    }
}

extension NotATextField {
    func testImplicitSelfUnrelated(string: String) {
        _ = text  // not a source: unrelated type
        arguments = [string]  // not a sink: unrelated type
    }
}
