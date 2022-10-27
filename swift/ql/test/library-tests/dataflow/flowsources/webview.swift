
// --- stubs ---
class WKUserContentController {}
class WKScriptMessage {}
protocol WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}
protocol NSCopying {}
protocol NSObjectProtocol {}
class JSValue {}
class JSContext {
    var globalObject: JSValue { get { return JSValue() } }
    func objectForKeyedSubscript(_: Any!) -> JSValue! { return JSValue() } 
    func setObject(_: Any, forKeyedSubscript: (NSCopying & NSObjectProtocol) ) {}
}

// --- tests ---
class TestMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { // SOURCE
    }
}

func testJsContext(context: JSContext) {
    context.globalObject // SOURCE
    context.objectForKeyedSubscript("") // SOURCE
    context.setObject(Exposed.self, forKeyedSubscript: "exposed" as! NSCopying & NSObjectProtocol)
}

class Exposed {
    var tainted: Any { get { return "" } } // SOURCE

    func tainted(arg1: Any, arg2: Any) { // SOURCES

    }
} 
