
// --- stubs ---

class NSObject
{
}

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

extension String {
	init(contentsOf: URL) throws {
        var data = ""

        // ...

        self.init(data)
    }
}

class NSURLRequest : NSObject
{
	enum CachePolicy : UInt
	{
		case useProtocolCachePolicy
	}
}

typealias TimeInterval = Double

class URLRequest
{
	typealias CachePolicy = NSURLRequest.CachePolicy

	init(url: URL, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60.0) {}
}

class Data
{
    init<S>(_ elements: S) {}
}

class WKNavigation : NSObject
{
}

class UIResponder : NSObject
{
}

class UIView : UIResponder
{
}

class UIWebView : UIView
{
	func loadRequest(_ request: URLRequest) {} // deprecated

	func load(_ data: Data, mimeType MIMEType: String, textEncodingName: String, baseURL: URL) {} // deprecated

	func loadHTMLString(_ string: String, baseURL: URL?) {} // deprecated
}

class WKWebView : UIView
{
	func load(_ request: URLRequest) -> WKNavigation? {
		// ...

		return WKNavigation()
	}

	func load(_ data: Data, mimeType MIMEType: String, characterEncodingName: String, baseURL: URL) -> WKNavigation? {
		// ...

		return WKNavigation()
	}

	func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
		// ...

		return WKNavigation()
	}
}

// --- tests ---

func getRemoteData() -> String {
	let url = URL(string: "http://example.com/")
	do
	{
		return try String(contentsOf: url!)
	} catch {
		return ""
	}
}

func testSimpleFlows() {
	let webview = UIWebView()

	webview.loadHTMLString(try! String(contentsOf: URL(string: "http://example.com/")!), baseURL: nil) // BAD

	let data = try! String(contentsOf: URL(string: "http://example.com/")!)
	webview.loadHTMLString(data, baseURL: nil) // BAD

	let url = URL(string: "http://example.com/")
	webview.loadHTMLString(try! String(contentsOf: url!), baseURL: nil) // BAD
}

func testUIWebView() {
	let webview = UIWebView()

	let localString = "<html><body><p>Local HTML</p></body></html>"
	let localStringFragment = "<body><p>Local HTML</p></body>"
	let remoteString = getRemoteData()

	webview.loadHTMLString(localString, baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString(getRemoteData(), baseURL: nil) // BAD: HTML contains remote input, may access local secrets
	webview.loadHTMLString(remoteString, baseURL: nil) // BAD

	webview.loadHTMLString("<html>" + localStringFragment + "</html>", baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString("<html>" + remoteString + "</html>", baseURL: nil) // BAD

	webview.loadHTMLString("<html>\(localStringFragment)</html>", baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString("<html>\(remoteString)</html>", baseURL: nil) // BAD

	let localSafeURL = URL(string: "about:blank")
	let localURL = URL(string: "http://example.com/")
	let remoteURL = URL(string: remoteString)
	let remoteURL2 = URL(string: "/path", relativeTo: remoteURL)

	webview.loadHTMLString(localString, baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.loadHTMLString(remoteString, baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.loadHTMLString(localString, baseURL: localURL!) // GOOD: a presumed safe baseURL is specified
	webview.loadHTMLString(remoteString, baseURL: localURL!) // GOOD: a presumed safe baseURL is specified
	webview.loadHTMLString(localString, baseURL: remoteURL!) // GOOD: the HTML data is local
	webview.loadHTMLString(remoteString, baseURL: remoteURL!) // BAD
	webview.loadHTMLString(localString, baseURL: remoteURL2!) // GOOD: the HTML data is local
	webview.loadHTMLString(remoteString, baseURL: remoteURL2!) // BAD

	let localRequest = URLRequest(url: localURL!)
	let remoteRequest = URLRequest(url: remoteURL!)

	webview.loadRequest(localRequest) // GOOD: loadRequest is out of scope as it has no baseURL
	webview.loadRequest(remoteRequest) // GOOD: loadRequest is out of scope as it has no baseURL

	let localData = Data(localString.utf8)
	let remoteData = Data(remoteString.utf8)
	webview.load(localData, mimeType: "text/html", textEncodingName: "utf-8", baseURL: localSafeURL!) // GOOD: the data is local
	webview.load(remoteData, mimeType: "text/html", textEncodingName: "utf-8", baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.load(localData, mimeType: "text/html", textEncodingName: "utf-8", baseURL: remoteURL!) // GOOD: the HTML data is local
	webview.load(remoteData, mimeType: "text/html", textEncodingName: "utf-8", baseURL: remoteURL!) // BAD
}

func testWKWebView() {
	let webview = WKWebView()
	// note: `WKWebView` is safer than `UIWebView` as it has better security configuration options
	//       and is more locked down by default.

	let localString = "<html><body><p>Local HTML</p></body></html>"
	let localStringFragment = "<body><p>Local HTML</p></body>"
	let remoteString = getRemoteData()

	webview.loadHTMLString(localString, baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString(getRemoteData(), baseURL: nil) // BAD
	webview.loadHTMLString(remoteString, baseURL: nil) // BAD

	webview.loadHTMLString("<html>" + localStringFragment + "</html>", baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString("<html>" + remoteString + "</html>", baseURL: nil) // BAD

	webview.loadHTMLString("<html>\(localStringFragment)</html>", baseURL: nil) // GOOD: the HTML data is local
	webview.loadHTMLString("<html>\(remoteString)</html>", baseURL: nil) // BAD

	let localSafeURL = URL(string: "about:blank")
	let localURL = URL(string: "http://example.com/")
	let remoteURL = URL(string: remoteString)
	let remoteURL2 = URL(string: "/path", relativeTo: remoteURL)

	webview.loadHTMLString(localString, baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.loadHTMLString(remoteString, baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.loadHTMLString(localString, baseURL: localURL!) // GOOD: a presumed safe baseURL is specified
	webview.loadHTMLString(remoteString, baseURL: localURL!) // GOOD: a presumed safe baseURL is specified
	webview.loadHTMLString(localString, baseURL: remoteURL!) // GOOD: the HTML data is local
	webview.loadHTMLString(remoteString, baseURL: remoteURL!) // BAD
	webview.loadHTMLString(localString, baseURL: remoteURL2!) // GOOD: the HTML data is local
	webview.loadHTMLString(remoteString, baseURL: remoteURL2!) // BAD

	let localRequest = URLRequest(url: localURL!)
	let remoteRequest = URLRequest(url: remoteURL!)

	webview.load(localRequest) // GOOD: loadRequest is out of scope as it has no baseURL
	webview.load(remoteRequest) // GOOD: loadRequest is out of scope as it has no baseURL

	let localData = Data(localString.utf8)
	let remoteData = Data(remoteString.utf8)
	webview.load(localData, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: localSafeURL!) // GOOD: the data is local
	webview.load(remoteData, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: localSafeURL!) // GOOD: a safe baseURL is specified
	webview.load(localData, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: remoteURL!) // GOOD: the HTML data is local
	webview.load(remoteData, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: remoteURL!) // BAD
}

func testQHelpExamples() {
	let webview = UIWebView()
	let htmlData = getRemoteData()

	// ...

	webview.loadHTMLString(htmlData, baseURL: nil) // BAD
	webview.loadHTMLString(htmlData, baseURL: URL(string: "about:blank")) // GOOD
}

testSimpleFlows()
testUIWebView()
testWKWebView()
testQHelpExamples()
