// --- stubs ---

func NSLog(_ format: String, _ args: CVarArg...) {}
func NSLogv(_ format: String, _ args: CVaListPointer) {}

struct OSLogType : RawRepresentable {
    static let `default` = OSLogType(rawValue: 0)
    let rawValue: UInt8
    init(rawValue: UInt8) { self.rawValue = rawValue}
}

struct OSLogStringAlignment {
    static var none = OSLogStringAlignment()
}

struct OSLogPrivacy {
    enum Mask { case none }
    static var auto = OSLogPrivacy()
    static var `private` = OSLogPrivacy()
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
	print(password) // $ MISSING: hasCleartextLogging=63
	print(password, separator: "") // $ MISSING: $ hasCleartextLogging=64
	print("", separator: password) // $ hasCleartextLogging=65
	print(password, separator: "", terminator: "") // $ MISSING: hasCleartextLogging=66
	print("", separator: password, terminator: "") // $ hasCleartextLogging=67
	print("", separator: "", terminator: password) // $ hasCleartextLogging=68

    NSLog(password) // $ hasCleartextLogging=70
    NSLog("%@", password as! CVarArg) // $ MISSING: hasCleartextLogging=71
    NSLog("%@ %@", "" as! CVarArg, password as! CVarArg) // $ MISSING: hasCleartextLogging=72
    NSLog("\(password)") // $ hasCleartextLogging=73
    NSLogv("%@", getVaList([password as! CVarArg])) // $ MISSING: hasCleartextLogging=74
    NSLogv("%@ %@", getVaList(["" as! CVarArg, password as! CVarArg])) // $ MISSING: hasCleartextLogging=75

    let log = Logger()
    log.log("\(password)") // $ hasCleartextLogging=78
    log.log("\(password, privacy: .private)") // Safe
    log.log(level: .default, "\(password)") // $ hasCleartextLogging=80
    log.trace("\(password)") // $ hasCleartextLogging=81
    log.debug("\(password)") // $ hasCleartextLogging=82
    log.info("\(password)") // $ hasCleartextLogging=83
    log.notice("\(password)") // $ hasCleartextLogging=84
    log.warning("\(password)") // $ hasCleartextLogging=85
    log.error("\(password)") // $ hasCleartextLogging=86
    log.critical("\(password)") // $ hasCleartextLogging=87
    log.fault("\(password)") // $ hasCleartextLogging=88
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