
// --- stubs ---

class NSObject {}

@MainActor class UIResponder : NSObject {}
@MainActor class UIView : UIResponder {}

@MainActor class NSResponder : NSObject {}
class NSView : NSResponder {}

class WKFrameInfo : NSObject {}
class WKContentWorld : NSObject {
	class var defaultClient: WKContentWorld { WKContentWorld() }
	class var page: WKContentWorld { WKContentWorld() }
}

class WKWebView : UIView {

	func evaluateJavaScript(
		_ javaScriptString: String
	) async throws -> Any { "" }

	func evaluateJavaScript(
		_ javaScriptString: String,
		completionHandler: ((Any?, Error?) -> Void)? = nil
	) {
		completionHandler?(nil, nil)
	}

	@MainActor func evaluateJavaScript(
		_ javaScript: String,
		in frame: WKFrameInfo? = nil,
		in contentWorld: WKContentWorld,
		completionHandler: ((Result<Any, Error>) -> Void)? = nil
	) {
		completionHandler?(.success(""))
	}

	@MainActor func evaluateJavaScript(
		_ javaScript: String,
		in frame: WKFrameInfo? = nil,
		contentWorld: WKContentWorld
	) async throws -> Any? { nil }

	@MainActor func callAsyncJavaScript(
		_ functionBody: String,
		arguments: [String : Any] = [:],
		in frame: WKFrameInfo? = nil,
		in contentWorld: WKContentWorld,
		completionHandler: ((Result<Any, Error>) -> Void)? = nil
	) {
		completionHandler?(.success(""))
	}

	@MainActor func callAsyncJavaScript(
		_ functionBody: String,
		arguments: [String : Any] = [:],
		in frame: WKFrameInfo? = nil,
		contentWorld: WKContentWorld
	) async throws -> Any? { nil }
}

enum WKUserScriptInjectionTime : Int, @unchecked Sendable {
	case atDocumentStart, atDocumentEnd
}

class WKUserScript : NSObject {
	init(
		source: String,
		injectionTime: WKUserScriptInjectionTime,
		forMainFrameOnly: Bool
	) {}

	init(
		source: String,
		injectionTime: WKUserScriptInjectionTime,
		forMainFrameOnly: Bool,
		in contentWorld: WKContentWorld
	) {}
}

class WKUserContentController : NSObject {
	func addUserScript(_ userScript: WKUserScript) {}
}

class UIWebView : UIView {
	// deprecated
	func stringByEvaluatingJavaScript(from script: String) -> String? { nil }
}

class WebView : NSView {
	// deprecated
	func stringByEvaluatingJavaScript(from script: String!) -> String! { "" }
}

class JSValue : NSObject {}

class JSContext {
	func evaluateScript(_ script: String!) -> JSValue! { return JSValue() }
	func evaluateScript(
		_ script: String!,
		withSourceURL sourceURL: URL!
	) -> JSValue! { return JSValue() }
}

typealias JSContextRef = OpaquePointer
typealias JSStringRef = OpaquePointer
typealias JSObjectRef = OpaquePointer
typealias JSValueRef = OpaquePointer
typealias JSChar = UInt16

func JSStringCreateWithCharacters(
    _ chars: UnsafePointer<JSChar>!,
    _ numChars: Int
) -> JSStringRef! {
	return chars.withMemoryRebound(to: CChar.self, capacity: numChars) {
		cchars in OpaquePointer(cchars)
	}
}
func JSStringCreateWithUTF8CString(_ string: UnsafePointer<CChar>!) -> JSStringRef! {
	return OpaquePointer(string)
}
func JSStringRetain(_ string: JSStringRef!) -> JSStringRef! { return string }
func JSStringRelease(_ string: JSStringRef!) { }

func JSEvaluateScript(
    _ ctx: JSContextRef!,
    _ script: JSStringRef!,
    _ thisObject: JSObjectRef!,
    _ sourceURL: JSStringRef!,
    _ startingLineNumber: Int32,
    _ exception: UnsafeMutablePointer<JSValueRef?>!
) -> JSValueRef! { return OpaquePointer(bitPattern: 0) }

@frozen
public struct Data: Collection {
	public typealias Index = Int
	public typealias Element = UInt8
	public subscript(x: Index) -> Element { 0 }
	public var startIndex: Index { 0 }
	public var endIndex: Index { 0 }
	public func index(after i: Index) -> Index { i + 1 }
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

extension String {
	init(contentsOf: URL) throws {
        let data = ""
        // ...
        self.init(data)
    }
}

// --- tests ---

func getRemoteData() -> String {
	let url = URL(string: "http://example.com/")
	do {
		return try String(contentsOf: url!)
	} catch {
		return ""
	}
}

func testAsync(_ sink: @escaping (String) async throws -> ()) {
	Task {
		let localString = "console.log('localString')"
		let localStringFragment = "'localStringFragment'"
		let remoteString = getRemoteData()

		try! await sink(localString) // GOOD: the HTML data is local
		try! await sink(try String(contentsOf: URL(string: "http://example.com/")!)) // BAD [NOT DETECTED - TODO]: HTML contains remote input, may access local secrets
		try! await sink(remoteString) // BAD [NOT DETECTED - TODO]

		try! await sink("console.log(" + localStringFragment + ")") // GOOD: the HTML data is local
		try! await sink("console.log(" + remoteString + ")") // BAD [NOT DETECTED - TODO]

		let localData = Data(localString.utf8)
		let remoteData = Data(remoteString.utf8)

		try! await sink(String(decoding: localData, as: UTF8.self)) // GOOD: the data is local
		try! await sink(String(decoding: remoteData, as: UTF8.self)) // BAD [NOT DETECTED - TODO]: the data is remote

		try! await sink("console.log(" + String(Int(localStringFragment) ?? 0) + ")") // GOOD: Primitive conversion
		try! await sink("console.log(" + String(Int(remoteString) ?? 0) + ")") // GOOD: Primitive conversion

		try! await sink("console.log(" + (localStringFragment.count != 0 ? "1" : "0") + ")") // GOOD: Primitive conversion
		try! await sink("console.log(" + (remoteString.count != 0 ? "1" : "0") + ")") // GOOD: Primitive conversion
	}
}

func testSync(_ sink: @escaping (String) -> ()) {
	let localString = "console.log('localString')"
	let localStringFragment = "'localStringFragment'"
	let remoteString = getRemoteData()

	sink(localString) // GOOD: the HTML data is local
	sink(try! String(contentsOf: URL(string: "http://example.com/")!)) // BAD: HTML contains remote input, may access local secrets
	sink(remoteString) // BAD

	sink("console.log(" + localStringFragment + ")") // GOOD: the HTML data is local
	sink("console.log(" + remoteString + ")") // BAD

	let localData = Data(localString.utf8)
	let remoteData = Data(remoteString.utf8)

	sink(String(decoding: localData, as: UTF8.self)) // GOOD: the data is local
	sink(String(decoding: remoteData, as: UTF8.self)) // BAD: the data is remote

	sink("console.log(" + String(Int(localStringFragment) ?? 0) + ")") // GOOD: Primitive conversion
	sink("console.log(" + String(Int(remoteString) ?? 0) + ")") // GOOD: Primitive conversion

	sink("console.log(" + (localStringFragment.count != 0 ? "1" : "0") + ")") // GOOD: Primitive conversion
	sink("console.log(" + (remoteString.count != 0 ? "1" : "0") + ")") // GOOD: Primitive conversion
}

func testUIWebView() {
	let webview = UIWebView()

	testAsync { string in
		_ = await webview.stringByEvaluatingJavaScript(from: string)
	}
}

func testWebView() {
	let webview = WebView()

	testAsync { string in
		_ = await webview.stringByEvaluatingJavaScript(from: string)
	}
}

func testWKWebView() {
	let webview = WKWebView()

	testAsync { string in
		_ = try await webview.evaluateJavaScript(string)
	}
	testAsync { string in
		await webview.evaluateJavaScript(string) { _, _ in }
	}
	testAsync { string in
		await webview.evaluateJavaScript(string, in: nil, in: WKContentWorld.defaultClient) { _ in }
	}
	testAsync { string in
		_ = try await webview.evaluateJavaScript(string, contentWorld: .defaultClient)
	}
	testAsync { string in
		await webview.callAsyncJavaScript(string, in: nil, in: .defaultClient) { _ in () }
	}
	testAsync { string in
		_ = try await webview.callAsyncJavaScript(string, contentWorld: WKContentWorld.defaultClient)
	}
}

func testWKUserContentController() {
	let ctrl = WKUserContentController()

	testSync { string in
		ctrl.addUserScript(WKUserScript(source: string, injectionTime: .atDocumentStart, forMainFrameOnly: false))
	}
	testSync { string in
		ctrl.addUserScript(WKUserScript(source: string, injectionTime: .atDocumentEnd, forMainFrameOnly: true, in: .defaultClient))
	}
}

func testJSContext() {
	let ctx = JSContext()

	testSync { string in
		_ = ctx.evaluateScript(string)
	}
	testSync { string in
		_ = ctx.evaluateScript(string, withSourceURL: URL(string: "https://example.com"))
	}
}

func testJSEvaluateScript() {
	testSync { string in
		string.utf16.withContiguousStorageIfAvailable { stringBytes in
			let jsstr = JSStringRetain(JSStringCreateWithCharacters(stringBytes.baseAddress, string.count))
			defer { JSStringRelease(jsstr) }
			_ = JSEvaluateScript(
				/*ctx:*/ OpaquePointer(bitPattern: 0),
				/*script:*/ jsstr,
				/*thisObject:*/ OpaquePointer(bitPattern: 0),
				/*sourceURL:*/ OpaquePointer(bitPattern: 0),
				/*startingLineNumber:*/ 0,
				/*exception:*/ UnsafeMutablePointer(bitPattern: 0)
			)
		}
	}
	testSync { string in
		string.utf8CString.withUnsafeBufferPointer { stringBytes in
			let jsstr = JSStringRetain(JSStringCreateWithUTF8CString(stringBytes.baseAddress))
			defer { JSStringRelease(jsstr) }
			_ = JSEvaluateScript(
				/*ctx:*/ OpaquePointer(bitPattern: 0),
				/*script:*/ jsstr,
				/*thisObject:*/ OpaquePointer(bitPattern: 0),
				/*sourceURL:*/ OpaquePointer(bitPattern: 0),
				/*startingLineNumber:*/ 0,
				/*exception:*/ UnsafeMutablePointer(bitPattern: 0)
			)
		}
	}
}

func testQHelpExamples() {
	Task {
		let webview = WKWebView()
		let remoteData = try String(contentsOf: URL(string: "http://example.com/evil.json")!)

		_ = try await webview.evaluateJavaScript("console.log(" + remoteData + ")") // BAD

		_ = try await webview.callAsyncJavaScript(
			"console.log(data)",
			arguments: ["data": remoteData], // GOOD
			contentWorld: .page
		)
	}
}

testUIWebView()
testWebView()
testWKWebView()
testWKUserContentController()
testJSContext()
testJSEvaluateScript()
testQHelpExamples()
