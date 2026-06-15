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
    print(password) // $ Alert
    print(password, separator: "") // $ Alert
    print("", separator: password) // $ Alert
    print(password, separator: "", terminator: "") // $ Alert
    print("", separator: password, terminator: "") // $ Alert
    print("", separator: "", terminator: password) // $ Alert
    print(passwordHash) // safe

    debugPrint(password) // $ Alert

    dump(password) // $ Alert

    NSLog(password) // $ Alert
    NSLog("%@", password) // $ Alert
    NSLog("%@ %@", "", password) // $ Alert
    NSLog("\(password)") // $ Alert
    NSLogv("%@", getVaList([password])) // $ Alert
    NSLogv("%@ %@", getVaList(["", password])) // $ Alert
    NSLog(passwordHash) // safe
    NSLogv("%@", getVaList([passwordHash])) // safe

    let bankAccount: Int = 0
    let log = Logger()
    // These MISSING test cases will be fixed when we properly generate the CFG around autoclosures.
    log.log("\(password)") // safe
    log.log("\(password, privacy: .auto)") // safe
    log.log("\(password, privacy: .private)") // safe
    log.log("\(password, privacy: .public)") // $ MISSING: Alert
    log.log("\(passwordHash, privacy: .public)") // safe
    log.log("\(password, privacy: .sensitive)") // safe
    log.log("\(bankAccount)") // $ MISSING: Alert
    log.log("\(bankAccount, privacy: .auto)") // $ MISSING: Alert
    log.log("\(bankAccount, privacy: .private)") // safe
    log.log("\(bankAccount, privacy: .public)") // $ MISSING: Alert
    log.log("\(bankAccount, privacy: .sensitive)") // safe
    log.log(level: .default, "\(password, privacy: .public)") // $ MISSING: Alert
    log.trace("\(password, privacy: .public)") // $ MISSING: Alert
    log.trace("\(passwordHash, privacy: .public)") // safe
    log.debug("\(password, privacy: .public)") // $ MISSING: Alert
    log.debug("\(passwordHash, privacy: .public)") // safe
    log.info("\(password, privacy: .public)") // $ MISSING: Alert
    log.info("\(passwordHash, privacy: .public)") // safe
    log.notice("\(password, privacy: .public)") // $ MISSING: Alert
    log.notice("\(passwordHash, privacy: .public)") // safe
    log.warning("\(password, privacy: .public)") // $ MISSING: Alert
    log.warning("\(passwordHash, privacy: .public)") // safe
    log.error("\(password, privacy: .public)") // $ MISSING: Alert
    log.error("\(passwordHash, privacy: .public)") // safe
    log.critical("\(password, privacy: .public)") // $ MISSING: Alert
    log.critical("\(passwordHash, privacy: .public)") // safe
    log.fault("\(password, privacy: .public)") // $ MISSING: Alert
    log.fault("\(passwordHash, privacy: .public)") // safe

    NSLog(passphrase) // $ Alert
    NSLog(pass_phrase) // $ Alert

    os_log("%@", log: .default, type: .default, "") // safe
    os_log("%@", log: .default, type: .default, password) // $ Alert
    os_log("%@ %@ %@", log: .default, type: .default, "", "", password) // $ Alert
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func getPassword() -> String { return "" }
func doSomething(password: String) { }

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSLog(x) // $ MISSING: Alert
	doSomething(password: x); // $ Source
	NSLog(x) // $ Alert

	let y = getPassword(); // $ Source
	NSLog(y) // $ Alert

	let z = MyClass()
	NSLog(z.harmless) // safe
	NSLog(z.password) // $ Alert
}

struct MyOuter {
	struct MyInner {
		var value: String
	}

	var password: MyInner
	var harmless: MyInner
}

func test3(mo : MyOuter) {
	// struct members...

	NSLog(mo.password.value) // $ Alert
	NSLog(mo.harmless.value) // safe
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

	print(password, to: &myString2) // $ Source
	print(myString2) // $ Alert

	print("log: " + password, to: &myString3) // $ Source
	print(myString3) // $ Alert

	debugPrint(harmless, to: &myString4)
	debugPrint(myString4) // safe

	debugPrint(password, to: &myString5) // $ Source
	debugPrint(myString5) // $ Alert

	dump(harmless, to: &myString6)
	dump(myString6) // safe

	dump(password, to: &myString7) // $ Source
	dump(myString7) // $ Alert

	myString8.write(harmless)
	print(myString8)

	myString9.write(password) // $ Source
	print(myString9) // $ Alert

	myString10.write(harmless)
	myString10.write(password) // $ Source
	myString10.write(harmless)
	print(myString10) // $ Alert

	harmless.write(to: &myString11)
	print(myString11)

	password.write(to: &myString12) // $ Source
	print(myString12) // $ Alert

	print(password, to: &myString13) // $ safe - only printed to another string
	debugPrint(password, to: &myString13) // $ safe - only printed to another string
	dump(password, to: &myString13) // $ safe - only printed to another string
	myString13.write(password) // safe - only printed to another string
	password.write(to: &myString13) // safe - only printed to another string
}

func test5(password: String, caseNum: Int) {
	// `assert` methods...
	// (these would only be a danger in certain builds)

	switch caseNum {
	case 0:
		assert(false, password) // $ Alert
	case 1:
		assertionFailure(password) // $ Alert
	case 2:
		precondition(false, password) // $ Alert
	case 3:
		preconditionFailure(password) // $ Alert
	default:
		fatalError(password) // $ Alert
	}
}

func test6(passwordString: String) {
    let e = NSException(name: NSExceptionName("exception"), reason: "\(passwordString) is incorrect!", userInfo: nil) // $ Alert
    e.raise()

    NSException.raise(NSExceptionName("exception"), format: "\(passwordString) is incorrect!", arguments: getVaList([])) // $ Alert
    NSException.raise(NSExceptionName("exception"), format: "%s is incorrect!", arguments: getVaList([passwordString])) // $ Alert

    _ = dprintf(0, "\(passwordString) is incorrect!") // $ Alert
    _ = dprintf(0, "%s is incorrect!", passwordString) // $ Alert
    _ = dprintf(0, "%s: %s is incorrect!", "foo", passwordString) // $ Alert
    _ = vprintf("\(passwordString) is incorrect!", getVaList([])) // $ Alert
    _ = vprintf("%s is incorrect!", getVaList([passwordString])) // $ Alert
    _ = vfprintf(nil, "\(passwordString) is incorrect!", getVaList([])) // $ Alert
    _ = vfprintf(nil, "%s is incorrect!", getVaList([passwordString])) // $ Alert
    _ = vasprintf_l(nil, nil, "\(passwordString) is incorrect!", getVaList([])) // good (`sprintf` is not logging)
    _ = vasprintf_l(nil, nil, "%s is incorrect!", getVaList([passwordString])) // good (`sprintf` is not logging)
}

func test7(authKey: String, authKey2: Int, authKey3: Float, password: String, secret: String) {
    log(message: authKey) // $ Alert
    log(message: String(authKey2)) // $ Alert
    logging(message: authKey) // $ MISSING: Alert
    logfile(file: 0, message: authKey) // $ MISSING: Alert
    logMessage(NSString(string: authKey)) // $ Alert
    logInfo(authKey) // $ Alert
    logError(errorMsg: authKey) // $ Alert
    harmless(authKey) // GOOD: not logging
    _ = logarithm(authKey3) // GOOD: not logging
    doLogin(login: authKey) // GOOD: not logging

    let logger = LogFile()
    let msg = "authKey: " + authKey // $ Source
    logger.log(msg) // $ Alert
    logger.trace(msg) // $ Alert
    logger.debug(msg) // $ Alert
    logger.info(NSString(string: msg)) // $ Alert
    logger.notice(msg) // $ Alert
    logger.warning(msg) // $ Alert
    logger.error(msg) // $ Alert
    logger.critical(msg) // $ Alert
    logger.fatal(msg) // $ Alert

    let logic = Logic()
    logic.addInt(authKey2) // GOOD: not logging
    logic.addString(authKey) // GOOD: not logging

    let rlogger = MyRemoteLogger()
    rlogger.setPassword(password: password) // GOOD: not logging
    rlogger.login(password: password) // GOOD: not logging
    rlogger.logout(secret: secret) // GOOD: not logging
}
