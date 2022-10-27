
// --- stubs ---
class WKScriptMessage {
    open var body: Any { get { return "" } }
}

// --- tests ---
func source() -> WKScriptMessage { return WKScriptMessage() }
func sink(s: Any) {}

func testInheritBodyTaint() {
    sink(s: source().body) // $ tainted=12
}
