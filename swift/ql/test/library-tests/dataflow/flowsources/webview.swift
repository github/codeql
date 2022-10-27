
// --- stubs ---
class WKUserContentController {}
class WKScriptMessage {}
protocol WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

// --- tests ---
class TestMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) { // SOURCE
    }
}