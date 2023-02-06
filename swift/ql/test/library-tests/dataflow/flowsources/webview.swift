
// --- stubs ---

class WKUserContentController {}

class WKScriptMessage {}

protocol WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

protocol WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void)
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
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
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { // SOURCE
    }
}

func testJsContext(context: JSContext) {
    context.globalObject // SOURCE
    context.objectForKeyedSubscript("") // SOURCE
}

protocol Exported : JSExport {
    var tainted: Any { get }
    func tainted(arg1: Any, arg2: Any)
}
class ExportedImpl : Exported {
    var tainted: Any { get { return "" } }

    var notTainted: Any { get { return ""} }

    func readFields() {
        tainted // SOURCE
        notTainted
    }

    func tainted(arg1: Any, arg2: Any) { // SOURCES
    }

    func notTainted(arg1: Any, arg2: Any) {
    }
} 

class WebViewDelegate : WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {} // SOURCE
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {} // SOURCE
}

class Extended {}

extension Extended : WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {} // SOURCE
    func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {} // SOURCE
}
