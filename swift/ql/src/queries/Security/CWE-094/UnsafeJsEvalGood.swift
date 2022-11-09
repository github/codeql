let webview: WKWebView
let remoteData = try String(contentsOf: URL(string: "http://example.com/evil.json")!)

...

_ = try await webview.callAsyncJavaScript(
    "alert(JSON.parse(data))",
    arguments: ["data": remoteData], // GOOD
    contentWorld: .page
)
