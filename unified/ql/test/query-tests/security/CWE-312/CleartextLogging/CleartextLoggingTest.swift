// --- stubs ---

class NSObject { }

func NSLog(_ format: String, _ args: CVarArg...) {}
func NSLogv(_ format: String, _ args: CVaListPointer) {}

func getVaList(_ args: [CVarArg]) -> CVaListPointer { return CVaListPointer(_fromUnsafeMutablePointer: UnsafeMutablePointer(bitPattern: 0)!) }

struct OSLogType : RawRepresentable {
    static let `default` = OSLogType(rawValue: 0)
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue}
}

struct OSLogStringAlignment {
    static var none = OSLogStringAlignment()
}

enum OSLogIntegerFormatting { case decimal }
enum OSLogInt32ExtendedFormat { case none }
enum OSLogFloatFormatting { case fixed }
enum OSLogBoolFormat { case truth }

struct OSLogPrivacy {
    enum Mask { case none }
    static var auto = OSLogPrivacy()
    static var `private` = OSLogPrivacy()
    static var `public` = OSLogPrivacy()
    static var sensitive = OSLogPrivacy()

    static func auto(mask: OSLogPrivacy.Mask) -> OSLogPrivacy { return .auto }
    static func `private`(mask: OSLogPrivacy.Mask) -> OSLogPrivacy { return .private }
    static func `sensitive`(mask: OSLogPrivacy.Mask) -> OSLogPrivacy { return .sensitive }
}

struct OSLogInterpolation : StringInterpolationProtocol {
    typealias StringLiteralType = String
    init(literalCapacity: Int, interpolationCount: Int) {}
    func appendLiteral(_: Self.StringLiteralType) {}
    mutating func appendInterpolation(_ argumentString: @autoclosure @escaping () -> String, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ argumentString: @autoclosure @escaping () -> String, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto, attributes: String) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int8, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int16, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int32, format: OSLogInt32ExtendedFormat, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int32, format: OSLogInt32ExtendedFormat, privacy: OSLogPrivacy = .auto, attributes: String) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int32, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Int64, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> UInt, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> UInt8, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> UInt16, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> UInt32, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> UInt64, format: OSLogIntegerFormatting = .decimal, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Double, format: OSLogFloatFormatting = .fixed, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Double, format: OSLogFloatFormatting = .fixed, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto, attributes: String) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Float,format: OSLogFloatFormatting = .fixed, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto) {}
    mutating func appendInterpolation(_ number: @autoclosure @escaping () -> Float, format: OSLogFloatFormatting = .fixed, align: OSLogStringAlignment = .none, privacy: OSLogPrivacy = .auto, attributes: String) {}
    mutating func appendInterpolation(_ boolean: @autoclosure @escaping () -> Bool, format: OSLogBoolFormat = .truth, privacy: OSLogPrivacy = .auto) {}
}

struct OSLogMessage : ExpressibleByStringInterpolation {
    typealias StringInterpolation = OSLogInterpolation
    typealias StringLiteralType = String
    typealias ExtendedGraphemeClusterLiteralType = String
    typealias UnicodeScalarLiteralType = String
    init(stringInterpolation: OSLogInterpolation) {}
    init(stringLiteral: String) {}
    init(extendedGraphemeClusterLiteral: String) {}
    init(unicodeScalarLiteral: String) {}
}

struct Logger {
    func log(_ message: OSLogMessage) {}
    func log(level: OSLogType, _ message: OSLogMessage) {}
    func notice(_: OSLogMessage) {}
    func debug(_: OSLogMessage) {}
    func trace(_: OSLogMessage) {}
    func info(_: OSLogMessage) {}
    func error(_: OSLogMessage) {}
    func warning(_: OSLogMessage) {}
    func fault(_: OSLogMessage) {}
    func critical(_: OSLogMessage) {}
}

class OSLog : NSObject {
    static let `default` = OSLog(rawValue: 0)
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue}
}

extension String : CVarArg {
  public var _cVarArgEncoding: [Int] { get { return [] } }
}

struct NSExceptionName {
    init(_ rawValue: String) {}
}

class NSException : NSObject
{
    init(name aName: NSExceptionName, reason aReason: String?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {}
    class func raise(_ name: NSExceptionName, format: String, arguments argList: CVaListPointer) {}
    func raise() {}
}

class NSString : NSObject {
    convenience init(string aString: String) { self.init() }
}

// from ObjC API; slightly simplified.
func os_log(_ message: StaticString,
    dso: UnsafeRawPointer? = nil,
    log: OSLog = .default,
    type: OSLogType = .default,
    _ args: CVarArg...) { }

// imported from C
typealias FILE = Int32 // this is a simplification
typealias wchar_t = Int32
typealias locale_t = OpaquePointer
func dprintf(_ fd: Int, _ format: UnsafePointer<Int8>, _ args: CVarArg...) -> Int32 { return 0 }
func vprintf(_ format: UnsafePointer<CChar>, _ arg: CVaListPointer) -> Int32 { return 0 }
func vfprintf(_ file: UnsafeMutablePointer<FILE>?, _ format: UnsafePointer<CChar>?, _ arg: CVaListPointer) -> Int32 { return 0 }
func vasprintf_l(_ ret: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?, _ loc: locale_t?, _ format: UnsafePointer<CChar>?, _ ap: CVaListPointer) -> Int32 { return 0 }

// custom
func log(message: String) {}
func logging(message: String) {}
func logfile(file: Int, message: String) {}
func logMessage(_ msg: NSString) {}
func logInfo(_ infoMsg: String) {}
func logError(errorMsg str: String) {}
func harmless(_ str: String) {} // safe
func logarithm(_ val: Float) -> Float { return 0.0 } // safe
func doLogin(login: String) {} // safe

// custom
class LogFile {
    func log(_ str: String) {}
    func trace(_ message: String?) {}
    func debug(_ message: String) {}
    func info(_ info: NSString) {}
    func notice(_ notice: String) {}
    func warning(_ warningMessage: String) {}
    func error(_ msg: String) {}
    func critical(_ criticalMsg: String) {}
    func fatal(_ str: String) {}
}

// custom
class Logic {
    func addInt(_ val: Int) {} // safe
    func addString(_ str: String) {} // safe
}

// custom
class MyRemoteLogger {
    func setPassword(password: String) { }
    func login(password: String) { }
    func logout(secret: String) { }
}

// --- tests ---

func test1(password: String, passwordHash : String, passphrase: String, pass_phrase: String) {
    print(password) // $ Alert[unified/swift/cleartext-logging]
    print(password, separator: "") // $ Alert[unified/swift/cleartext-logging]
    print("", separator: password) // $ Alert[unified/swift/cleartext-logging]
    print(password, separator: "", terminator: "") // $ Alert[unified/swift/cleartext-logging]
    print("", separator: password, terminator: "") // $ Alert[unified/swift/cleartext-logging]
    print("", separator: "", terminator: password) // $ Alert[unified/swift/cleartext-logging]
    print(passwordHash) // safe

    debugPrint(password) // $ MISSING: Alert[unified/swift/cleartext-logging]

    dump(password) // $ MISSING: Alert[unified/swift/cleartext-logging]

    NSLog(password) // $ Alert[unified/swift/cleartext-logging]
    NSLog("%@", password) // $ Alert[unified/swift/cleartext-logging]
    NSLog("%@ %@", "", password) // $ Alert[unified/swift/cleartext-logging]
    NSLog("\(password)") // $ Alert[unified/swift/cleartext-logging]
    NSLogv("%@", getVaList([password])) // $ Alert[unified/swift/cleartext-logging]
    NSLogv("%@ %@", getVaList(["", password])) // $ Alert[unified/swift/cleartext-logging]
    NSLog(passwordHash) // safe
    NSLogv("%@", getVaList([passwordHash])) // safe

    let bankAccount: Int = 0
    let log = Logger()
    // These MISSING test cases will be fixed when we properly generate the CFG around autoclosures.
    log.log("\(password)") // $ SPURIOUS: Alert[unified/swift/cleartext-logging] safe
    log.log("\(password, privacy: .auto)") // safe
    log.log("\(password, privacy: .private)") // safe
    log.log("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.log("\(passwordHash, privacy: .public)") // safe
    log.log("\(password, privacy: .sensitive)") // safe
    log.log("\(bankAccount)") // $ Alert[unified/swift/cleartext-logging]
    log.log("\(bankAccount, privacy: .auto)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.log("\(bankAccount, privacy: .private)") // safe
    log.log("\(bankAccount, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.log("\(bankAccount, privacy: .sensitive)") // safe
    log.log(level: .default, "\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.trace("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.trace("\(passwordHash, privacy: .public)") // safe
    log.debug("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.debug("\(passwordHash, privacy: .public)") // safe
    log.info("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.info("\(passwordHash, privacy: .public)") // safe
    log.notice("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.notice("\(passwordHash, privacy: .public)") // safe
    log.warning("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.warning("\(passwordHash, privacy: .public)") // safe
    log.error("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.error("\(passwordHash, privacy: .public)") // safe
    log.critical("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.critical("\(passwordHash, privacy: .public)") // safe
    log.fault("\(password, privacy: .public)") // $ MISSING: Alert[unified/swift/cleartext-logging]
    log.fault("\(passwordHash, privacy: .public)") // safe

    NSLog(passphrase) // $ Alert[unified/swift/cleartext-logging]
    NSLog(pass_phrase) // $ Alert[unified/swift/cleartext-logging]

    os_log("%@", log: .default, type: .default, "") // safe
    os_log("%@", log: .default, type: .default, password) // $ MISSING: Alert[unified/swift/cleartext-logging]
    os_log("%@ %@ %@", log: .default, type: .default, "", "", password) // $ MISSING: Alert[unified/swift/cleartext-logging]
}

class MyClass {
	var harmless = "abc"
	var password = "123"

	func getPassword() -> String { return "" }
}

func getPassword() -> String { return "" }
func doSomething(password: String) { }

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSLog(x) // $ MISSING: Alert
	doSomething(password: x); // $ MISSING: Source[unified/swift/cleartext-logging]
	NSLog(x) // $ MISSING: Alert[unified/swift/cleartext-logging]

	let y = getPassword(); // $ Alert[unified/swift/cleartext-logging]
	NSLog(y) // $ Sink[unified/swift/cleartext-logging]

	let z = MyClass()
	NSLog(z.harmless) // safe
	NSLog(z.password) // $ Alert[unified/swift/cleartext-logging]
	NSLog(z.getPassword()) // $ Alert[unified/swift/cleartext-logging]
}

struct MyOuter {
	struct MyInner {
		var value: String

		func getValue() -> String { return "" }
	}

	var password: MyInner
	var harmless: MyInner
}

func test3(mo : MyOuter) {
	// struct members...

	NSLog(mo.password.value) // $ Alert[unified/swift/cleartext-logging]
	NSLog(mo.harmless.value) // safe

	NSLog(mo.password.getValue()) // $ Alert[unified/swift/cleartext-logging]
	NSLog(mo.harmless.getValue()) // safe
}

func test4(harmless: String, password: String) {
	// functions with an `in:` target for the write...
	var myString1 = ""
	var myString2 = ""
	var myString3 = ""
	var myString4 = ""
	var myString5 = ""
	var myString6 = ""
	var myString7 = ""
	var myString8 = ""
	var myString9 = ""
	var myString10 = ""
	var myString11 = ""
	var myString12 = ""
	var myString13 = ""

	print(harmless, to: &myString1)
	print(myString1) // safe

	print(password, to: &myString2) // $ MISSING: Source[unified/swift/cleartext-logging] SPURIOUS: Alert[unified/swift/cleartext-logging]
	print(myString2) // $ MISSING: Alert[unified/swift/cleartext-logging]

	print("log: " + password, to: &myString3) // $ MISSING: Source[unified/swift/cleartext-logging] SPURIOUS: Alert[unified/swift/cleartext-logging]
	print(myString3) // $ MISSING: Alert[unified/swift/cleartext-logging]

	debugPrint(harmless, to: &myString4)
	debugPrint(myString4) // safe

	debugPrint(password, to: &myString5) // $ MISSING: Source[unified/swift/cleartext-logging]
	debugPrint(myString5) // $ MISSING: Alert[unified/swift/cleartext-logging]

	dump(harmless, to: &myString6)
	dump(myString6) // safe

	dump(password, to: &myString7) // $ MISSING: Source[unified/swift/cleartext-logging]
	dump(myString7) // $ MISSING: Alert[unified/swift/cleartext-logging]

	myString8.write(harmless)
	print(myString8)

	myString9.write(password) // $ Alert[unified/swift/cleartext-logging]
	print(myString9) // $ Sink[unified/swift/cleartext-logging]

	myString10.write(harmless)
	myString10.write(password) // $ Alert[unified/swift/cleartext-logging]
	myString10.write(harmless)
	print(myString10) // $ Sink[unified/swift/cleartext-logging]

	harmless.write(to: &myString11)
	print(myString11)

	password.write(to: &myString12) // $ Alert[unified/swift/cleartext-logging]
	print(myString12) // $ Sink[unified/swift/cleartext-logging]

	print(password, to: &myString13) // $ SPURIOUS: Alert[unified/swift/cleartext-logging] safe - only printed to another string
	debugPrint(password, to: &myString13) // safe - only printed to another string
	dump(password, to: &myString13) // safe - only printed to another string
	myString13.write(password) // safe - only printed to another string
	password.write(to: &myString13) // safe - only printed to another string
}

func test5(password: String, caseNum: Int) {
	// `assert` methods...
	// (these would only be a danger in certain builds)

	switch caseNum {
	case 0:
		assert(false, password) // $ MISSING: Alert[unified/swift/cleartext-logging]
	case 1:
		assertionFailure(password) // $ MISSING: Alert[unified/swift/cleartext-logging]
	case 2:
		precondition(false, password) // $ MISSING: Alert[unified/swift/cleartext-logging]
	case 3:
		preconditionFailure(password) // $ MISSING: Alert[unified/swift/cleartext-logging]
	default:
		fatalError(password) // $ MISSING: Alert[unified/swift/cleartext-logging]
	}
}

func test6(passwordString: String) {
    let e = NSException(name: NSExceptionName("exception"), reason: "\(passwordString) is incorrect!", userInfo: nil) // $ MISSING: Alert[unified/swift/cleartext-logging]
    e.raise()

    NSException.raise(NSExceptionName("exception"), format: "\(passwordString) is incorrect!", arguments: getVaList([])) // $ MISSING: Alert[unified/swift/cleartext-logging]
    NSException.raise(NSExceptionName("exception"), format: "%s is incorrect!", arguments: getVaList([passwordString])) // $ MISSING: Alert[unified/swift/cleartext-logging]

    _ = dprintf(0, "\(passwordString) is incorrect!") // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = dprintf(0, "%s is incorrect!", passwordString) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = dprintf(0, "%s: %s is incorrect!", "foo", passwordString) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = vprintf("\(passwordString) is incorrect!", getVaList([])) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = vprintf("%s is incorrect!", getVaList([passwordString])) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = vfprintf(nil, "\(passwordString) is incorrect!", getVaList([])) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = vfprintf(nil, "%s is incorrect!", getVaList([passwordString])) // $ MISSING: Alert[unified/swift/cleartext-logging]
    _ = vasprintf_l(nil, nil, "\(passwordString) is incorrect!", getVaList([])) // good (`sprintf` is not logging)
    _ = vasprintf_l(nil, nil, "%s is incorrect!", getVaList([passwordString])) // good (`sprintf` is not logging)
}

func test7(authKey: String, authKey2: Int, authKey3: Float, password: String, secret: String) {
    log(message: authKey) // $ Alert[unified/swift/cleartext-logging]
    log(message: String(authKey2)) // $ Alert[unified/swift/cleartext-logging]
    logging(message: authKey) // $ Alert[unified/swift/cleartext-logging]
    logfile(file: 0, message: authKey) // $ Alert[unified/swift/cleartext-logging]
    logMessage(NSString(string: authKey)) // $ Alert[unified/swift/cleartext-logging]
    logInfo(authKey) // $ Alert[unified/swift/cleartext-logging]
    logError(errorMsg: authKey) // $ Alert[unified/swift/cleartext-logging]
    harmless(authKey) // GOOD: not logging
    _ = logarithm(authKey3) // $ SPURIOUS: Alert[unified/swift/cleartext-logging] GOOD: not logging
    doLogin(login: authKey) // GOOD: not logging

    let logger = LogFile()
    let msg = "authKey: " + authKey // $ Alert[unified/swift/cleartext-logging]
    logger.log(msg) // $ Sink[unified/swift/cleartext-logging]
    logger.trace(msg) // $ MISSING: Sink[unified/swift/cleartext-logging]
    logger.debug(msg) // $ MISSING: Sink[unified/swift/cleartext-logging]
    logger.info(NSString(string: msg)) // $ MISSING: Sink[unified/swift/cleartext-logging]
    logger.notice(msg) // $ MISSING: Sink[unified/swift/cleartext-logging]
    logger.warning(msg) // $ Sink[unified/swift/cleartext-logging]
    logger.error(msg) // $ Sink[unified/swift/cleartext-logging]
    logger.critical(msg) // $ MISSING: Sink[unified/swift/cleartext-logging]
    logger.fatal(msg) // $ MISSING: Sink[unified/swift/cleartext-logging]

    let logic = Logic()
    logic.addInt(authKey2) // GOOD: not logging
    logic.addString(authKey) // GOOD: not logging

    let rlogger = MyRemoteLogger()
    rlogger.setPassword(password: password) // GOOD: not logging
    rlogger.login(password: password) // $ SPURIOUS: Alert[unified/swift/cleartext-logging] GOOD: not logging
    rlogger.logout(secret: secret) // $ SPURIOUS: Alert[unified/swift/cleartext-logging] GOOD: not logging
}

let globalMessage = "example"
let globalPassword = "example"

func testGlobals(a: Password, b: Info) {
    print(globalMessage) // safe
    print(globalPassword) // $ Alert[unified/swift/cleartext-logging]
}

enum Password {
    case value(String)
}

enum Info {
    case password(String)
    case message(String)
}

func testEnums(p: Password, i: Info) {
    // print the value from the Password enum
    if case .value(let contents) = p {
        print(contents) // $ MISSING: Alert[unified/swift/cleartext-logging]
    }

    // print the values from the Info enum
    switch i {
    case .password(let contents):
        print(contents) // $ MISSING: Alert[unified/swift/cleartext-logging]
    case .message(let contents):
        print(contents) // safe
    }
}
