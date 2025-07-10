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
    print(password) // $ hasCleartextLogging=167
    print(password, separator: "") // $ $ hasCleartextLogging=168
    print("", separator: password) // $ hasCleartextLogging=169
    print(password, separator: "", terminator: "") // $ hasCleartextLogging=170
    print("", separator: password, terminator: "") // $ hasCleartextLogging=171
    print("", separator: "", terminator: password) // $ hasCleartextLogging=172
    print(passwordHash) // safe

    debugPrint(password) // $ hasCleartextLogging=175

    dump(password) // $ hasCleartextLogging=177

    NSLog(password) // $ hasCleartextLogging=179
    NSLog("%@", password) // $ hasCleartextLogging=180
    NSLog("%@ %@", "", password) // $ hasCleartextLogging=181
    NSLog("\(password)") // $ hasCleartextLogging=182
    NSLogv("%@", getVaList([password])) // $ hasCleartextLogging=183
    NSLogv("%@ %@", getVaList(["", password])) // $ hasCleartextLogging=184
    NSLog(passwordHash) // safe
    NSLogv("%@", getVaList([passwordHash])) // safe

    let bankAccount: Int = 0
    let log = Logger()
    // These MISSING test cases will be fixed when we properly generate the CFG around autoclosures.
    log.log("\(password)") // safe
    log.log("\(password, privacy: .auto)") // safe
    log.log("\(password, privacy: .private)") // safe
    log.log("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=194
    log.log("\(passwordHash, privacy: .public)") // safe
    log.log("\(password, privacy: .sensitive)") // safe
    log.log("\(bankAccount)") // $ MISSING: hasCleartextLogging=197
    log.log("\(bankAccount, privacy: .auto)") // $ MISSING: hasCleartextLogging=198
    log.log("\(bankAccount, privacy: .private)") // safe
    log.log("\(bankAccount, privacy: .public)") // $ MISSING: hasCleartextLogging=200
    log.log("\(bankAccount, privacy: .sensitive)") // safe
    log.log(level: .default, "\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=202
    log.trace("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=203
    log.trace("\(passwordHash, privacy: .public)") // safe
    log.debug("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=205
    log.debug("\(passwordHash, privacy: .public)") // safe
    log.info("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=207
    log.info("\(passwordHash, privacy: .public)") // safe
    log.notice("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=209
    log.notice("\(passwordHash, privacy: .public)") // safe
    log.warning("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=211
    log.warning("\(passwordHash, privacy: .public)") // safe
    log.error("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=213
    log.error("\(passwordHash, privacy: .public)") // safe
    log.critical("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=215
    log.critical("\(passwordHash, privacy: .public)") // safe
    log.fault("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=217
    log.fault("\(passwordHash, privacy: .public)") // safe

    NSLog(passphrase) // $ hasCleartextLogging=220
    NSLog(pass_phrase) // $ hasCleartextLogging=221

    os_log("%@", log: .default, type: .default, "") // safe
    os_log("%@", log: .default, type: .default, password) // $ hasCleartextLogging=224
    os_log("%@ %@ %@", log: .default, type: .default, "", "", password) // $ hasCleartextLogging=225
}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func getPassword() -> String { return "" }
func doSomething(password: String) { }

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSLog(x) // $ MISSING: hasCleartextLogging=240
	doSomething(password: x);
	NSLog(x) // $ hasCleartextLogging=240

	let y = getPassword();
	NSLog(y) // $ hasCleartextLogging=243

	let z = MyClass()
	NSLog(z.harmless) // safe
	NSLog(z.password) // $ hasCleartextLogging=248
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

	NSLog(mo.password.value) // $ hasCleartextLogging=263
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

	print(password, to: &myString2)
	print(myString2) // $ hasCleartextLogging=286

	print("log: " + password, to: &myString3)
	print(myString3) // $ hasCleartextLogging=289

	debugPrint(harmless, to: &myString4)
	debugPrint(myString4) // safe

	debugPrint(password, to: &myString5)
	debugPrint(myString5) // $ hasCleartextLogging=295

	dump(harmless, to: &myString6)
	dump(myString6) // safe

	dump(password, to: &myString7)
	dump(myString7) // $ hasCleartextLogging=301

	myString8.write(harmless)
	print(myString8)

	myString9.write(password)
	print(myString9) // $ hasCleartextLogging=307

	myString10.write(harmless)
	myString10.write(password)
	myString10.write(harmless)
	print(myString10) // $ hasCleartextLogging=311

	harmless.write(to: &myString11)
	print(myString11)

	password.write(to: &myString12)
	print(myString12) // $ hasCleartextLogging=318

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
		assert(false, password) // $ hasCleartextLogging=334
	case 1:
		assertionFailure(password) // $ hasCleartextLogging=336
	case 2:
		precondition(false, password) // $ hasCleartextLogging=338
	case 3:
		preconditionFailure(password) // $ hasCleartextLogging=340
	default:
		fatalError(password) // $ hasCleartextLogging=342
	}
}

func test6(passwordString: String) {
    let e = NSException(name: NSExceptionName("exception"), reason: "\(passwordString) is incorrect!", userInfo: nil) // $ hasCleartextLogging=347
    e.raise()

    NSException.raise(NSExceptionName("exception"), format: "\(passwordString) is incorrect!", arguments: getVaList([])) // $ hasCleartextLogging=350
    NSException.raise(NSExceptionName("exception"), format: "%s is incorrect!", arguments: getVaList([passwordString])) // $ hasCleartextLogging=351

    _ = dprintf(0, "\(passwordString) is incorrect!") // $ hasCleartextLogging=353
    _ = dprintf(0, "%s is incorrect!", passwordString) // $ hasCleartextLogging=354
    _ = dprintf(0, "%s: %s is incorrect!", "foo", passwordString) // $ hasCleartextLogging=355
    _ = vprintf("\(passwordString) is incorrect!", getVaList([])) // $ hasCleartextLogging=356
    _ = vprintf("%s is incorrect!", getVaList([passwordString])) // $ hasCleartextLogging=357
    _ = vfprintf(nil, "\(passwordString) is incorrect!", getVaList([])) // $ hasCleartextLogging=358
    _ = vfprintf(nil, "%s is incorrect!", getVaList([passwordString])) // $ hasCleartextLogging=359
    _ = vasprintf_l(nil, nil, "\(passwordString) is incorrect!", getVaList([])) // good (`sprintf` is not logging)
    _ = vasprintf_l(nil, nil, "%s is incorrect!", getVaList([passwordString])) // good (`sprintf` is not logging)
}

func test7(authKey: String, authKey2: Int, authKey3: Float, password: String, secret: String) {
    log(message: authKey) // $ hasCleartextLogging=365
    log(message: String(authKey2)) // $ hasCleartextLogging=366
    logging(message: authKey) // $ MISSING: hasCleartextLogging=367
    logfile(file: 0, message: authKey) // $ MISSING: hasCleartextLogging=368
    logMessage(NSString(string: authKey)) // $ hasCleartextLogging=369
    logInfo(authKey) // $ hasCleartextLogging=370
    logError(errorMsg: authKey) // $ hasCleartextLogging=371
    harmless(authKey) // GOOD: not logging
    _ = logarithm(authKey3) // GOOD: not logging
    doLogin(login: authKey) // GOOD: not logging

    let logger = LogFile()
    let msg = "authKey: " + authKey
    logger.log(msg) // $ hasCleartextLogging=377
    logger.trace(msg) // $ hasCleartextLogging=377
    logger.debug(msg) // $ hasCleartextLogging=377
    logger.info(NSString(string: msg)) // $ hasCleartextLogging=377
    logger.notice(msg) // $ hasCleartextLogging=377
    logger.warning(msg) // $ hasCleartextLogging=377
    logger.error(msg) // $ hasCleartextLogging=377
    logger.critical(msg) // $ hasCleartextLogging=377
    logger.fatal(msg) // $ hasCleartextLogging=377

    let logic = Logic()
    logic.addInt(authKey2) // GOOD: not logging
    logic.addString(authKey) // GOOD: not logging

    let rlogger = MyRemoteLogger()
    rlogger.setPassword(password: password) // GOOD: not logging
    rlogger.login(password: password) // GOOD: not logging
    rlogger.logout(secret: secret) // GOOD: not logging
}
