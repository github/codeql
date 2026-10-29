
// --- stubs ---

class WKUserContentController {}

class WKScriptMessage {}

protocol WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

protocol WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) // $ SPURIOUS?: source=remote
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) // $ SPURIOUS?: source=remote
}

class WKWebView {}

class WKNavigationAction {}

class WKWebpagePreferences {}

enum WKNavigationActionPolicy {}

protocol NSCopying {}

protocol NSObjectProtocol {}

class JSValue {}

class JSContext {
    var globalObject: JSValue { get { return JSValue() } }
    func objectForKeyedSubscript(_: Any!) -> JSValue! { return JSValue() }
    func setObject(_: Any, forKeyedSubscript: (NSCopying & NSObjectProtocol) ) {}
}

protocol JSExport {}

// --- tests ---

class TestMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { // $ source=remote
    }
}

func testJsContext(context: JSContext) {
    context.globalObject // $ source=remote
    context.objectForKeyedSubscript("") // $ source=remote
}

protocol Exported : JSExport {
    var tainted: Any { get }
    func tainted(arg1: Any, arg2: Any)
}

class ExportedImpl : Exported {
    var tainted: Any { get { return "" } }

    var notTainted: Any { get { return ""} }

    func readFields() {
        tainted // $ source=remote
        notTainted
    }

    func tainted(arg1: Any, arg2: Any) { // $ source=remote
    }

    func notTainted(arg1: Any, arg2: Any) {
    }
}

class WebViewDelegate : WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {} // $ source=remote
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {} // $ source=remote
}

class Extended {}

extension Extended : WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {} // $ source=remote
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {} // $ source=remote
}

// ---

typealias JSExportAlias = JSExport

protocol Exported2 : JSExportAlias {
    var tainted: Any { get }
}
typealias Exported2Alias = Exported2

class ExportedImpl2 : Exported2Alias {
    var tainted: Any { get { return "" } }
    var notTainted: Any { get { return ""} }

    func readFields() {
        tainted // $ source=remote
        notTainted
    }
}
