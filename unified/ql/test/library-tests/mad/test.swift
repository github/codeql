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
    c1.encryptionKey = key  // $ isSink=encryption-key // nested types are not yet resolved by type inference

    var c2 = configuration
    c2.encryptionKey = key  // $ isSink=encryption-key // nested types are not yet resolved by type inference
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
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        syncConfiguration: nil,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        readOnly: false,
        schemaVersion: 0,
        migrationBlock: nil,
        deleteRealmIfMigrationNeeded: false,
        shouldCompactOnLaunch: nil,
        objectTypes: nil)

    _ = Realm.Configuration.init(
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        syncConfiguration: nil,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        readOnly: false,
        schemaVersion: 0,
        migrationBlock: nil,
        deleteRealmIfMigrationNeeded: false,
        shouldCompactOnLaunch: nil,
        objectTypes: nil)

    _ = Realm.Configuration(
        fileURL: fileURL,  // $ isSink=path-injection
        inMemoryIdentifier: nil,
        syncConfiguration: nil,
        encryptionKey: encryptionKey,  // $ isSink=encryption-key
        readOnly: false,
        schemaVersion: 0,
        migrationBlock: nil,
        deleteRealmIfMigrationNeeded: false,
        shouldCompactOnLaunch: nil,
        objectTypes: nil,
        seedFilePath: seedFilePath)  // $ isSink=path-injection
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

class ShorthandTest {
    func sourceParams(_ x: String) {}

    func sinkArgs(_ x: String) {}
}

class ShorthandTestSub: ShorthandTest {
    override func sourceParams(
        _ x: String  // $ isSource=shorthand-source
    ) {
        _ = self
    }  // $ isSource=shorthand-source
}

func testShorthandTokens(obj: ShorthandTest, string: String) {
    obj.sinkArgs(
        string  // $ isSink=shorthand-sink
    )  // $ isSink=shorthand-sink
}

class SubscriptTest {
    subscript(i: Int) -> String {
        get { "" }
        set {}
    }
}

class SubscriptTestSub: SubscriptTest {
    override subscript(i: Int) -> String {
        get { "" }
        set(v) {  // $ isSource=subscript-setter-source
            _ = v
        }
    }
}

func testSubscripts(obj: SubscriptTest, string: String) {
    _ = obj[0]  // $ isSink=subscript-getter-sink
    obj[0] = string  // $ isSink=subscript-setter-sink
}

class OptionalTest {
    func source(_ x: String, y: Int = 0) {}
    func named(a: String, b: Int = 0) {}
    func named(x: String, b: Int) {}
    func positional(_ x: String, _ y: Int = 0) {}
    func mixed(_ x: String, x y: Int = 0) {}
}

class OptionalTestSub: OptionalTest {
    override func source(
        _ x: String,  // $ isSource=optional-source
        y: Int = 0
    ) {}
}

class OptionalInit {
    init(value: String, flag: Bool = false) {}
}

func testOptionalParameters(obj: OptionalTest, string: String) {
    obj.named(a: string)  // $ isSink=optional-named-sink
    obj.named(a: string, b: 1)  // $ isSink=optional-named-sink
    obj.named(a: string, c: 1)  // not a sink: unknown label
    obj.named(b: 1, a: string)  // not a sink: wrong order
    obj.named(x: string)  // not a sink: `b` is required here
    obj.named(x: string, b: 1)  // $ isSink=required-named-sink

    obj.positional(string)  // $ isSink=optional-positional-sink
    obj.positional(string, 1)  // $ isSink=optional-positional-sink
    obj.positional(string, 1, 2)  // not a sink: too many arguments
    obj.positional()  // not a sink: too few arguments

    obj.mixed(string)  // $ isSink=optional-mixed-sink
    obj.mixed(string, x: 1)  // $ isSink=optional-mixed-sink
    obj.mixed(string, 1)  // not a sink: missing label

    _ = OptionalInit(value: string)  // $ isSink=optional-init-sink
    _ = OptionalInit(value: string, flag: true)  // $ isSink=optional-init-sink
    _ = OptionalInit(flag: true)  // not a sink: missing required argument
}
