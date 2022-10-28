
// --- stubs ---
class WKScriptMessage {
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

// --- tests ---
func source() -> Any { return "" }
func sink(_: Any) {}

func testInheritBodyTaint() {
    sink((source() as! WKScriptMessage).body) // $ tainted=52
}

func testJsValue() {
    let s = source()
    
    let source = s as! JSValue
    sink(source.toObject() as Any) // $ tainted=56
    sink(source.toObjectOf(NSNumber.self) as Any) // $ tainted=56
    sink(source.toBool()) // $ tainted=56
    sink(source.toDouble()) // $ tainted=56
    sink(source.toInt32()) // $ tainted=56
    sink(source.toUInt32()) // $ tainted=56
    sink(source.toNumber() as Any) // $ tainted=56
    sink(source.toString() as Any) // $ tainted=56
    sink(source.toDate() as Any) // $ tainted=56
    sink(source.toArray() as Any) // $ tainted=56
    sink(source.toDictionary() as Any) // $ tainted=56
    sink(source.toPoint()) // $ tainted=56
    sink(source.toRange()) // $ tainted=56
    sink(source.toRect()) // $ tainted=56
    sink(source.toSize()) // $ tainted=56
    sink(source.atIndex(0) as Any) // $ tainted=56
    sink(source.forProperty("") as Any) // $ tainted=56

    let context = JSContext()
    sink(JSValue(object: s as Any, in: context)) // $ tainted=56
    sink(JSValue(bool: s as! Bool, in: context)) // $ tainted=56
    sink(JSValue(double: s as! Double, in: context)) // $ tainted=56
    sink(JSValue(int32: s as! Int32, in: context)) // $ tainted=56
    sink(JSValue(uInt32: s as! UInt32, in: context)) // $ tainted=56
    sink(JSValue(point: s as! CGPoint, in: context)) // $ tainted=56
    sink(JSValue(range: s as! NSRange, in: context)) // $ tainted=56
    sink(JSValue(rect: s as! CGRect, in: context)) // $ tainted=56
    sink(JSValue(size: s as! CGSize, in: context)) // $ tainted=56
    
    let v1 = JSValue(object: "", in: context)
    v1.defineProperty("", descriptor: s as Any)
    sink(v1) // $ tainted=56

    let v2 = JSValue(object: "", in: context)
    v2.setValue(s as Any, at: 0)
    sink(v2) // $ tainted=56

    let v3 = JSValue(object: "", in: context)
    v3.setValue(s as Any, forProperty: "")
    sink(v3) // $ tainted=56
}
