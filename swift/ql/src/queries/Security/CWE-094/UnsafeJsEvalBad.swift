let webview: WKWebView
let remoteData = try String(contentsOf: URL(string: "http://example.com/evil.json")!)

...

_ = try await webview.evaluateJavaScript("alert(" + remoteData + ")") // BAD
