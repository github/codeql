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

// from ObjC API; slightly simplified.
func os_log(_ message: StaticString,
    dso: UnsafeRawPointer? = nil,
    log: OSLog = .default,
    type: OSLogType = .default,
    _ args: CVarArg...) { }

// --- tests ---

func test1(password: String, passwordHash : String, passphrase: String, pass_phrase: String) {
    print(password) // $ hasCleartextLogging=105
    print(password, separator: "") // $ $ hasCleartextLogging=106
    print("", separator: password) // $ hasCleartextLogging=107
    print(password, separator: "", terminator: "") // $ hasCleartextLogging=108
    print("", separator: password, terminator: "") // $ hasCleartextLogging=109
    print("", separator: "", terminator: password) // $ hasCleartextLogging=110
    print(passwordHash) // safe

    debugPrint(password) // $ hasCleartextLogging=113

    dump(password) // $ hasCleartextLogging=115

    NSLog(password) // $ hasCleartextLogging=117
    NSLog("%@", password) // $ hasCleartextLogging=118
    NSLog("%@ %@", "", password) // $ hasCleartextLogging=119
    NSLog("\(password)") // $ hasCleartextLogging=120
    NSLogv("%@", getVaList([password])) // $ hasCleartextLogging=121
    NSLogv("%@ %@", getVaList(["", password])) // $ hasCleartextLogging=122
    NSLog(passwordHash) // safe
    NSLogv("%@", getVaList([passwordHash])) // safe

    let bankAccount: Int = 0
    let log = Logger()
    // These MISSING test cases will be fixed when we properly generate the CFG around autoclosures.
    log.log("\(password)") // safe
    log.log("\(password, privacy: .auto)") // safe
    log.log("\(password, privacy: .private)") // safe
    log.log("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=132
    log.log("\(passwordHash, privacy: .public)") // safe
    log.log("\(password, privacy: .sensitive)") // safe
    log.log("\(bankAccount)") // $ MISSING: hasCleartextLogging=135
    log.log("\(bankAccount, privacy: .auto)") // $ MISSING: hasCleartextLogging=136
    log.log("\(bankAccount, privacy: .private)") // safe
    log.log("\(bankAccount, privacy: .public)") // $ MISSING: hasCleartextLogging=138
    log.log("\(bankAccount, privacy: .sensitive)") // safe
    log.log(level: .default, "\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=140
    log.trace("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=141
    log.trace("\(passwordHash, privacy: .public)") // safe
    log.debug("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=143
    log.debug("\(passwordHash, privacy: .public)") // safe
    log.info("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=145
    log.info("\(passwordHash, privacy: .public)") // safe
    log.notice("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=147
    log.notice("\(passwordHash, privacy: .public)") // safe
    log.warning("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=149
    log.warning("\(passwordHash, privacy: .public)") // safe
    log.error("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=151
    log.error("\(passwordHash, privacy: .public)") // safe
    log.critical("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=153
    log.critical("\(passwordHash, privacy: .public)") // safe
    log.fault("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=155
    log.fault("\(passwordHash, privacy: .public)") // safe

    NSLog(passphrase) // $ hasCleartextLogging=158
    NSLog(pass_phrase) // $ hasCleartextLogging=159

    os_log("%@", log: .default, type: .default, "") // safe
    os_log("%@", log: .default, type: .default, password) // $ hasCleartextLogging=162
    os_log("%@ %@ %@", log: .default, type: .default, "", "", password) // $ hasCleartextLogging=163

}

class MyClass {
	var harmless = "abc"
	var password = "123"
}

func getPassword() -> String { return "" }
func doSomething(password: String) { }

func test3(x: String) {
	// alternative evidence of sensitivity...

	NSLog(x) // $ MISSING: hasCleartextLogging=179
	doSomething(password: x);
	NSLog(x) // $ hasCleartextLogging=179

	let y = getPassword();
	NSLog(y) // $ hasCleartextLogging=182

	let z = MyClass()
	NSLog(z.harmless) // safe
	NSLog(z.password) // $ hasCleartextLogging=187
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

	NSLog(mo.password.value) // $ hasCleartextLogging=202
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
	print(myString2) // $ hasCleartextLogging=225

	print("log: " + password, to: &myString3)
	print(myString3) // $ hasCleartextLogging=228

	debugPrint(harmless, to: &myString4)
	debugPrint(myString4) // safe

	debugPrint(password, to: &myString5)
	debugPrint(myString5) // $ hasCleartextLogging=234

	dump(harmless, to: &myString6)
	dump(myString6) // safe

	dump(password, to: &myString7)
	dump(myString7) // $ hasCleartextLogging=240

	myString8.write(harmless)
	print(myString8)

	myString9.write(password)
	print(myString9) // $ hasCleartextLogging=246

	myString10.write(harmless)
	myString10.write(password)
	myString10.write(harmless)
	print(myString10) // $ hasCleartextLogging=250

	harmless.write(to: &myString11)
	print(myString11)

	password.write(to: &myString12)
	print(myString12) // $ hasCleartextLogging=257

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
		assert(false, password) // $ MISSING: hasCleartextLogging=273
	case 1:
		assertionFailure(password) // $ MISSING: hasCleartextLogging=275
	case 2:
		precondition(false, password) // $ MISSING: hasCleartextLogging=277
	case 3:
		preconditionFailure(password) // $ MISSING: hasCleartextLogging=279
	default:
		fatalError(password) // $ MISSING: hasCleartextLogging=281
	}
}
