
// --- stubs ---

class NSObject {}

class WKScriptMessage : NSObject {
    open var body: Any { get { return "" } }
}

class NSNumber {
    init(value: Int) {}
}

class Date {}

class CGPoint {}

class NSRange {}

class CGRect {}

class CGSize{}

class JSContext {}

class JSValue {
    init(object: Any, in: JSContext) {}
    init(bool: Bool, in: JSContext) {}
    init(double: Double, in: JSContext) {}
    init(int32: Int32, in: JSContext) {}
    init(uInt32: UInt32, in: JSContext) {}
    init(point: CGPoint, in: JSContext) {}
    init(range: NSRange, in: JSContext) {}
    init(rect: CGRect, in: JSContext) {}
    init(size: CGSize, in: JSContext) {}
    func toObject() -> Any! { return "" }
    func toObjectOf(_: AnyClass!) -> Any! { return "" }
    func toBool() -> Bool { return false }
    func toDouble() -> Double { return 0.0 }
    func toInt32() -> Int32 { return 0 }
    func toUInt32() -> UInt32 { return 0 }
    func toNumber() -> NSNumber! { return NSNumber(value: 0) }
    func toString() -> String! { return "" }
    func toDate() -> Date! { return Date() }
    func toArray() -> [Any]! { return [""] }
    func toDictionary() -> [AnyHashable: Any]! { return ["": ""]}
    func toPoint() -> CGPoint { return CGPoint() }
    func toRange() -> NSRange { return NSRange() }
    func toRect() -> CGRect { return CGRect() }
    func toSize() -> CGSize { return CGSize() }
    func atIndex(_: Int) -> JSValue! { return JSValue(object: "", in: JSContext()) }
    func defineProperty(_: Any!, descriptor: Any!) {}
    func forProperty(_: Any!) -> JSValue! { return JSValue(object: "", in: JSContext()) }
    func setValue(_: Any!, at: Int) {}
    func setValue(_: Any!, forProperty: Any!) {}
}

enum WKUserScriptInjectionTime : Int {
    case atDocumentStart = 0
}

class WKContentWorld : NSObject {}

class WKUserScript : NSObject {
    init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool) {}
    init(source: String, injectionTime: WKUserScriptInjectionTime, forMainFrameOnly: Bool, in contentWorld: WKContentWorld) {}

    var source: String { get { return "" } }
}

// --- tests ---

func source() -> Any { return "" }
func sink(_: Any) {}

func testInheritBodyTaint() {
    sink((source() as! WKScriptMessage).body) // $ tainted=77
}

func testJsValue() {
    let s = source()

    let source = s as! JSValue
    sink(source.toObject() as Any) // $ tainted=81
    sink(source.toObjectOf(NSNumber.self) as Any) // $ tainted=81
    sink(source.toBool()) // $ tainted=81
    sink(source.toDouble()) // $ tainted=81
    sink(source.toInt32()) // $ tainted=81
    sink(source.toUInt32()) // $ tainted=81
    sink(source.toNumber() as Any) // $ tainted=81
    sink(source.toString() as Any) // $ tainted=81
    sink(source.toDate() as Any) // $ tainted=81
    sink(source.toArray() as Any) // $ tainted=81
    sink(source.toDictionary() as Any) // $ tainted=81
    sink(source.toPoint()) // $ tainted=81
    sink(source.toRange()) // $ tainted=81
    sink(source.toRect()) // $ tainted=81
    sink(source.toSize()) // $ tainted=81
    sink(source.atIndex(0) as Any) // $ tainted=81
    sink(source.forProperty("") as Any) // $ tainted=81

    let context = JSContext()
    sink(JSValue(object: s as Any, in: context)) // $ tainted=81
    sink(JSValue(bool: s as! Bool, in: context)) // $ tainted=81
    sink(JSValue(double: s as! Double, in: context)) // $ tainted=81
    sink(JSValue(int32: s as! Int32, in: context)) // $ tainted=81
    sink(JSValue(uInt32: s as! UInt32, in: context)) // $ tainted=81
    sink(JSValue(point: s as! CGPoint, in: context)) // $ tainted=81
    sink(JSValue(range: s as! NSRange, in: context)) // $ tainted=81
    sink(JSValue(rect: s as! CGRect, in: context)) // $ tainted=81
    sink(JSValue(size: s as! CGSize, in: context)) // $ tainted=81

    let v1 = JSValue(object: "", in: context)
    v1.defineProperty("", descriptor: s as Any)
    sink(v1) // $ tainted=81

    let v2 = JSValue(object: "", in: context)
    v2.setValue(s as Any, at: 0)
    sink(v2) // $ tainted=81

    let v3 = JSValue(object: "", in: context)
    v3.setValue(s as Any, forProperty: "")
    sink(v3) // $ tainted=81
}

func testWKUserScript() {
    let atStart = WKUserScriptInjectionTime.atDocumentStart
    let a = WKUserScript(source: "abc", injectionTime: atStart, forMainFrameOnly: false)
    sink(a)
    sink(a.source)

    let b = WKUserScript(source: source() as! String, injectionTime: atStart, forMainFrameOnly: false)
    sink(b) // $ tainted=132
    sink(b.source) // $ tainted=132

    let world = WKContentWorld()
    let c = WKUserScript(source: source() as! String, injectionTime: atStart, forMainFrameOnly: false, in: world)
    sink(c) // $ tainted=137
    sink(c.source) // $ tainted=137
}
