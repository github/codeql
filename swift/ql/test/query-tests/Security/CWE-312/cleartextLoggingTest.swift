// --- stubs ---

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

// --- tests ---

func test1(password: String, passwordHash : String) {
	print(password) // $ MISSING: hasCleartextLogging=87
	print(password, separator: "") // $ MISSING: $ hasCleartextLogging=88
	print("", separator: password) // $ hasCleartextLogging=89
	print(password, separator: "", terminator: "") // $ MISSING: hasCleartextLogging=90
	print("", separator: password, terminator: "") // $ hasCleartextLogging=91
	print("", separator: "", terminator: password) // $ hasCleartextLogging=92

    NSLog(password) // $ hasCleartextLogging=94
    NSLog("%@", password as! CVarArg) // $ MISSING: hasCleartextLogging=95
    NSLog("%@ %@", "" as! CVarArg, password as! CVarArg) // $ MISSING: hasCleartextLogging=96
    NSLog("\(password)") // $ hasCleartextLogging=97
    NSLogv("%@", getVaList([password as! CVarArg])) // $ MISSING: hasCleartextLogging=98
    NSLogv("%@ %@", getVaList(["" as! CVarArg, password as! CVarArg])) // $ MISSING: hasCleartextLogging=99

    let bankAccount: Int = 0
    let log = Logger()
    // These MISSING test cases will be fixed when we properly generate the CFG around autoclosures.
    log.log("\(password)") // Safe
    log.log("\(password, privacy: .auto)") // Safe
    log.log("\(password, privacy: .private)") // Safe
    log.log("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=107
    log.log("\(password, privacy: .sensitive)") // Safe
    log.log("\(bankAccount)") // $ MISSING: hasCleartextLogging=109
    log.log("\(bankAccount, privacy: .auto)") // $ MISSING: hasCleartextLogging=110
    log.log("\(bankAccount, privacy: .private)") // Safe
    log.log("\(bankAccount, privacy: .public)") // $ MISSING: hasCleartextLogging=112
    log.log("\(bankAccount, privacy: .sensitive)") // Safe
    log.log(level: .default, "\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=114
    log.trace("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=115
    log.debug("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=116
    log.info("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=117
    log.notice("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=118
    log.warning("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=119
    log.error("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=120
    log.critical("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=121
    log.fault("\(password, privacy: .public)") // $ MISSING: hasCleartextLogging=122
}
/*
class MyClass {
	var harmless = "abc"
	var password = "123"
}

func test3(x: String) {
	// alternative evidence of sensitivity...

	UserDefaults.standard.set(x, forKey: "myKey") // $ MISSING: hasCleartextLogging
	doSomething(password: x);
	UserDefaults.standard.set(x, forKey: "myKey") // $ hasCleartextLogging

	let y = getPassword();
	UserDefaults.standard.set(y, forKey: "myKey") // $ hasCleartextLogging

	let z = MyClass()
	UserDefaults.standard.set(z.harmless, forKey: "myKey") // Safe
	UserDefaults.standard.set(z.password, forKey: "myKey") // $ hasCleartextLogging
}

func test4(passwd: String) {
	// sanitizers...

	var x = passwd;
	var y = passwd;
	var z = passwd;

	UserDefaults.standard.set(x, forKey: "myKey") // $ hasCleartextLogging
	UserDefaults.standard.set(y, forKey: "myKey") // $ hasCleartextLogging
	UserDefaults.standard.set(z, forKey: "myKey") // $ hasCleartextLogging

	x = encrypt(x);
	hash(data: &y);
	z = "";

	UserDefaults.standard.set(x, forKey: "myKey") // Safe
	UserDefaults.standard.set(y, forKey: "myKey") // Safe
	UserDefaults.standard.set(z, forKey: "myKey") // Safe
}
*/