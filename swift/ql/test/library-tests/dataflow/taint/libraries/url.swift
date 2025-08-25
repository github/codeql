
class NSObject
{
}

struct URL
{
	typealias BookmarkResolutionOptions = NSURL.BookmarkResolutionOptions

	struct URLResourceKey : Hashable {
		init(_ rawValue: String) { }
		init(rawValue: String) { }

		// …
	}

	struct URLResourceValues {
		var name: String?
		var path: String?
		var canonicalPath: String?
		var localizedLabel: String?
		var localizedName: String?
		var parentDirectory: URL?

		// …
	}

	struct AsyncBytes {
		// …
	}

	enum DirectoryHint {
		case inferFromPath
	}

	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
	init(fileURLWithPath path: String) { }
	init(fileURLWithPath path: String, isDirectory: Bool) { }
	init(fileURLWithPath path: String, relativeTo base: URL?) { }
	init(fileURLWithPath path: String, isDirectory: Bool, relativeTo base: URL?) { }
	init(fileURLWithFileSystemRepresentation path: UnsafePointer<Int8>, isDirectory: Bool, relativeTo baseURL: URL?) { }
	init(fileReferenceLiteralResourceName name: String) { }
	init?(_ path: FilePath) { }
	init?(_ path: FilePath, isDirectory: Bool) { }
	init(resolvingBookmarkData data: Data, options: URL.BookmarkResolutionOptions = [], relativeTo url: URL? = nil, bookmarkDataIsStale: inout Bool) throws { }
	init(resolvingAliasFileAt url: URL, options: URL.BookmarkResolutionOptions = []) throws { }
	init?(resource: URLResource) { }
	init?(dataRepresentation: Data, relativeTo url: URL?, isAbsolute: Bool = false) { }
	init?(filePath path: FilePath, directoryHint: URL.DirectoryHint = .inferFromPath) { }
	init(filePath path: String, directoryHint: URL.DirectoryHint = .inferFromPath, relativeTo base: URL? = nil) { }

	var dataRepresentation: Data { get { return Data(0) } }
	var absoluteString: String { get { return "" } }
	var absoluteURL: URL { get {return URL(string: "")!} }
	var baseURL: URL { get {return URL(string: "")!} }
	var fragment: String? { get {return nil} }
	var host: String? { get {return nil} }
	var lastPathComponent: String { get {return ""} }
	var path: String { get {return ""} }
	var pathComponents: [String] { get {return [""]} }
	var pathExtension: String { get {return ""} }
	var port: Int? { get {return nil} }
	var query: String? { get {return nil} }
	var relativePath: String { get {return ""} }
	var relativeString: String { get {return ""} }
	var scheme: String? { get {return nil} }
	var standardized: URL { get {return URL(string: "")!} }
	var standardizedFileURL: URL { get {return URL(string: "")!} }
	var user: String? { get {return nil} }
	var password: String? { get {return nil} }
	var resourceBytes: URL.AsyncBytes { get { return (nil as AsyncBytes?)! } }
	var lines: AsyncLineSequence<URL.AsyncBytes> { get { return (nil as AsyncLineSequence<URL.AsyncBytes>?)! } }

	func resourceValues(forKeys keys: Set<URLResourceKey>) throws -> URLResourceValues { return URLResourceValues() }
	static func resourceValues(forKeys keys: Set<URLResourceKey>, fromBookmarkData data: Data) -> URLResourceValues? { return nil }
	mutating func setResourceValues(_ values: URLResourceValues) throws { }
	mutating func setTemporaryResourceValue(_ value: Any, forKey key: URLResourceKey) { }
	func withUnsafeFileSystemRepresentation<ResultType>(_ block: (UnsafePointer<Int8>?) throws -> ResultType) rethrows -> ResultType { return (nil as ResultType?)! }
	func resolvingSymlinksInPath() -> URL { return URL(string: "")! }
	mutating func appendPathComponent(_ pathComponent: String) { }
	mutating func appendPathComponent(_ pathComponent: String, isDirectory: Bool) { }
	func appendingPathComponent(_ pathComponent: String) -> URL {	 return URL(string: "")! }
	func appendingPathComponent(_ pathComponent: String, isDirectory: Bool) -> URL { return URL(string: "")! }
	mutating func appendPathExtension(_ pathExtension: String) { }
	func appendingPathExtension(_ pathExtension: String) -> URL {  return URL(string: "")! }
	func deletingLastPathComponent() -> URL { return URL(string: "")! }
	func deletingPathExtension() -> URL { return URL(string: "")! }
	mutating func append<S>(component: S, directoryHint: URL.DirectoryHint = .inferFromPath) where S: StringProtocol { }
	mutating func append<S>(components: S..., directoryHint: URL.DirectoryHint = .inferFromPath) where S: StringProtocol { }
	mutating func append<S>(path: S, directoryHint: URL.DirectoryHint = .inferFromPath) where S: StringProtocol { }
	mutating func append(queryItems: [URLQueryItem]) { }
	func appending<S>(component: S, directoryHint: URL.DirectoryHint = .inferFromPath) -> URL where S: StringProtocol { return URL(string: "")! }
	func appending<S>(components: S..., directoryHint: URL.DirectoryHint = .inferFromPath) -> URL where S: StringProtocol { return URL(string: "")! }
	func appending<S>(path: S, directoryHint: URL.DirectoryHint = .inferFromPath) -> URL where S: StringProtocol { return URL(string: "")! }
	func appending(queryItems: [URLQueryItem]) -> URL { return URL(string: "")! }
	func promisedItemResourceValues(forKeys keys: Set<URLResourceKey>) throws -> URLResourceValues { return (nil as URLResourceValues?)! }
	func formatted() -> String { return "" }
	func fragment(percentEncoded: Bool = true) -> String? { return nil }
	func host(percentEncoded: Bool = true) -> String? { return nil }
	func password(percentEncoded: Bool = true) -> String? { return nil }
	func path(percentEncoded: Bool = true) -> String { return "" }
	func query(percentEncoded: Bool = true) -> String? { return nil }
	func user(percentEncoded: Bool = true) -> String? { return nil }

	// simplified:
	func bookmarkData(options: Int = 0, includingResourceValuesForKeys keys: Set<URLResourceKey>? = nil, relativeTo url: URL? = nil) throws -> Data { return Data(0) }
	static func bookmarkData(withContentsOf url: URL) throws -> Data { return Data(0) }

	static var homeDirectory: URL { get { return URL(string: "")! } }
	static func homeDirectory(forUser user: String) -> URL? { return nil }
}

class NSURL {
	struct BookmarkResolutionOptions : OptionSet {
		let rawValue: Int
	}

	init?(string: String) {}
}

class Data
{
    init<S>(_ elements: S) {}
}

struct FilePath {
	init(_ string: String) {}
}

struct AsyncLineSequence<Base> : AsyncSequence {
	typealias Element = String
	struct AsyncIterator : AsyncIteratorProtocol {
		typealias Element = String
		mutating func next() async -> String? { return nil }
	}
	func makeAsyncIterator() -> AsyncIterator { return AsyncIterator() }
}

class InputStream {}

struct Mirror {}

typealias TimeInterval = Double

struct URLResource {
	// simplified:
	init(name: String, subdirectory: String? = nil, locale: Int = 0, bundle: Int = 0) {
		self.name = name
		self.subdirectory = subdirectory
	}

	let name: String
	let subdirectory: String?
}

struct URLRequest : CustomStringConvertible, CustomDebugStringConvertible {
	enum CachePolicy { case none }
	enum NetworkServiceType { case none }
	enum Attribution { case none }
	var cachePolicy: CachePolicy = .none
	var httpMethod: String? = ""
	var url: URL? = URL(string: "")
	var httpBody: Data? = Data("")
	var httpBodyStream: InputStream? = nil
	var mainDocument: URL = URL(string: "")!
	var mainDocumentURL: URL? = URL(string: "")
	var allHTTPHeaderFields: [String : String]? = nil
	var timeoutInterval: TimeInterval = TimeInterval()
	var httpShouldHandleCookies: Bool = false
	var httpShouldUsePipelining: Bool = false
	var allowsCellularAccess: Bool = false
	var allowsConstrainedNetworkAccess: Bool = false
	var allowsExpensiveNetworkAccess: Bool = false
	var networkServiceType: NetworkServiceType = .none
	var attribution: Attribution = .none
	var description: String = ""
	var debugDescription: String = ""
	var customMirror: Mirror = Mirror()
	var hashValue: Int = 0
	var assumesHTTP3Capable: Bool = false
	var requiresDNSSECValidation: Bool = false
}

struct URLQueryItem { }

class URLResponse : NSObject { }

class URLSessionTask : NSObject { }

class URLSessionDataTask : URLSessionTask { }

class URLSession {
	class var shared: URLSession { get { return URLSession() } }

	func dataTask(
    with url: URL,
    completionHandler: (Data?, URLResponse?, Error?) -> Void
) -> URLSessionDataTask { return URLSessionDataTask() }
}

func source() -> Any { return "" }
func sink(arg: URL) {}
func sink(data: Data) {}
func sink(string: String) {}
func sink(int: Int) {}
func sink(any: Any) {}
func taintThroughURL() {
	let clean = "http://example.com/"
	let tainted = source() as! String
	let urlClean = URL(string: clean)!
	let urlTainted = URL(string: tainted)!

	sink(arg: urlClean)
	sink(arg: urlTainted) // $ tainted=210
	// Fields
	sink(data: urlTainted.dataRepresentation) // $ tainted=210
	sink(string: urlTainted.absoluteString) // $ tainted=210
	sink(arg: urlTainted.absoluteURL) // $ tainted=210
	sink(arg: urlTainted.baseURL) // $ tainted=210
	sink(string: urlTainted.fragment!) // $ tainted=210
	sink(string: urlTainted.host!) // $ tainted=210
	sink(string: urlTainted.lastPathComponent) // $ tainted=210
	sink(string: urlTainted.path) // $ tainted=210
	sink(string: urlTainted.pathComponents[0]) // $ tainted=210
	sink(string: urlTainted.pathExtension) // $ tainted=210
	sink(int: urlTainted.port!) // $ tainted=210
	sink(string: urlTainted.query!) // $ tainted=210
	sink(string: urlTainted.relativePath) // $ tainted=210
	sink(string: urlTainted.relativeString) // $ tainted=210
	sink(string: urlTainted.scheme!) // $ tainted=210
	sink(arg: urlTainted.standardized) // $ tainted=210
	sink(arg: urlTainted.standardizedFileURL) // $ tainted=210
	sink(string: urlTainted.user!) // $ tainted=210
	sink(string: urlTainted.password!) // $ tainted=210
	sink(any: urlTainted.resourceBytes) // $ tainted=210

	sink(arg: URL(string: clean, relativeTo: nil)!)
	sink(arg: URL(string: tainted, relativeTo: nil)!) // $ tainted=210
	sink(arg: URL(string: clean, relativeTo: urlClean)!)
	// Fields (assuming `clean` was a relative path instead of a full URL)
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.absoluteURL) // $ tainted=210
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.baseURL) // $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.fragment!) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.host!) // $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.lastPathComponent) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.path) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.pathComponents[0]) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.pathExtension) // $ $ tainted=210
	sink(int: URL(string: clean, relativeTo: urlTainted)!.port!) // $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.query!) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.relativePath) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.relativeString) // $ $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.scheme!) // $ tainted=210
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.standardized) // $ tainted=210
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.standardizedFileURL) // $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.user!) // $ tainted=210
	sink(string: URL(string: clean, relativeTo: urlTainted)!.password!) // $ tainted=210

	if let x = URL(string: clean) {
		sink(arg: x)
	}
	if let y = URL(string: tainted) {
		sink(arg: y) // $ tainted=210
	}

	var urlClean2 : URL!
	urlClean2 = URL(string: clean)
	sink(arg: urlClean2)

	var urlTainted2 : URL!
	urlTainted2 = URL(string: tainted)
	sink(arg: urlTainted2) // $ tainted=210

	let _ = URLSession.shared.dataTask(with: urlTainted) { (data, response, error) in
		sink(data: data!) // $ tainted=210
	}

	sink(arg: URL(fileURLWithPath: tainted)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: tainted, isDirectory: false)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: tainted, relativeTo: urlClean)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: clean, relativeTo: urlTainted)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: tainted, isDirectory: false, relativeTo: urlClean)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: clean, isDirectory: false, relativeTo: urlTainted)) // $ tainted=210
	sink(arg: URL(fileURLWithPath: tainted)) // $ tainted=210

	let _ = clean.withCString({
		ptrClean in
		sink(arg: URL(fileURLWithFileSystemRepresentation: ptrClean, isDirectory: false, relativeTo: nil))
		sink(arg: URL(fileURLWithFileSystemRepresentation: ptrClean, isDirectory: false, relativeTo: urlTainted)) // $ tainted=210
	});
	sink(arg: URL(fileURLWithFileSystemRepresentation: 0 as! UnsafePointer<Int8>, isDirectory: false, relativeTo: urlTainted)) // $ tainted=210
	let _ = tainted.withCString({
		ptrTainted in
		sink(arg: URL(fileURLWithFileSystemRepresentation: ptrTainted, isDirectory: false, relativeTo: nil)) // $ MISSING: tainted=210
	})

	sink(arg: URL(fileReferenceLiteralResourceName: tainted)) // $ tainted=210
	sink(arg: URL(FilePath(tainted))!) // $ tainted=210
	sink(arg: URL(FilePath(tainted), isDirectory: false)!) // $ tainted=210

	if let values = try? urlTainted.resourceValues(forKeys: []) {
		sink(any: values) // $ tainted=210
		sink(string: values.name!) // $ tainted=210
		sink(string: values.path!) // $ tainted=210
		sink(string: values.canonicalPath!) // $ tainted=210
		sink(string: values.localizedLabel!) // $ tainted=210
		sink(string: values.localizedName!) // $ tainted=210
		sink(any: values.parentDirectory!) // $ tainted=210
	}
	if let values = try? urlTainted.promisedItemResourceValues(forKeys: []) {
		sink(any: values) // $ tainted=210
		sink(string: values.name!) // $ tainted=210
		sink(string: values.path!) // $ tainted=210
		sink(string: values.canonicalPath!) // $ tainted=210
		sink(string: values.localizedLabel!) // $ tainted=210
		sink(string: values.localizedName!) // $ tainted=210
		sink(any: values.parentDirectory!) // $ tainted=210
	}

	urlClean.withUnsafeFileSystemRepresentation({
		ptr in
		sink(any: ptr!)
	})
	urlTainted.withUnsafeFileSystemRepresentation({
		ptr in
		sink(any: ptr!) // $ tainted=210
	})

	sink(arg: urlTainted.resolvingSymlinksInPath()) // $ tainted=210
	sink(arg: urlTainted.appendingPathComponent(clean)) // $ tainted=210
	sink(arg: urlClean.appendingPathComponent(tainted)) // $ tainted=210
	sink(arg: urlTainted.appendingPathComponent(clean, isDirectory: false)) // $ tainted=210
	sink(arg: urlClean.appendingPathComponent(tainted, isDirectory: false)) // $ tainted=210
	sink(arg: urlTainted.appendingPathExtension(clean)) // $ tainted=210
	sink(arg: urlClean.appendingPathExtension(tainted)) // $ tainted=210
	sink(arg: urlTainted.deletingLastPathComponent()) // $ tainted=210
	sink(arg: urlTainted.deletingPathExtension()) // $ tainted=210
	sink(arg: urlTainted.appending(component: clean)) // $ tainted=210
	sink(arg: urlClean.appending(component: tainted)) // $ tainted=210
	sink(arg: urlTainted.appending(components: clean)) // $ tainted=210
	sink(arg: urlClean.appending(components: tainted)) // $ MISSING: tainted=210
	sink(arg: urlClean.appending(components: clean, tainted)) // $ MISSING: tainted=210
	sink(arg: urlTainted.appending(path: clean)) // $ tainted=210
	sink(arg: urlClean.appending(path: tainted)) // $ tainted=210
	sink(arg: urlTainted.appending(queryItems: [])) // $ tainted=210
	sink(arg: urlClean.appending(queryItems: [source() as! URLQueryItem])) // $ MISSING: tainted=210

	sink(arg: URL(filePath: tainted)) // $ tainted=210
	sink(arg: URL(filePath: tainted, relativeTo: nil)) // $ tainted=210
	sink(arg: URL(filePath: clean, relativeTo: urlTainted)) // $ tainted=210
	sink(arg: try! URL(resolvingAliasFileAt: urlTainted)) // $ tainted=210
	sink(arg: URL(resource: URLResource(name: tainted))!) // $ tainted=210
	sink(arg: URL(resource: URLResource(name: clean, subdirectory: tainted))!) // $ tainted=210

	let dataClean = Data(clean)
	let dataTainted = Data(tainted)
	var stale = true
	sink(arg: URL(dataRepresentation: dataTainted, relativeTo: urlClean)!) // $ tainted=210
	sink(arg: URL(dataRepresentation: dataClean, relativeTo: urlTainted)!) // $ tainted=210
	sink(arg: try! URL(resolvingBookmarkData: dataTainted, bookmarkDataIsStale: &stale)) // $ tainted=210
	sink(arg: try! URL(resolvingBookmarkData: dataClean, relativeTo: urlTainted, bookmarkDataIsStale: &stale)) // $ tainted=210

	sink(string: urlTainted.formatted()) // $ tainted=210
	sink(string: urlTainted.fragment()!) // $ tainted=210
	sink(string: urlTainted.host()!) // $ tainted=210
	sink(string: urlTainted.password()!) // $ tainted=210
	sink(string: urlTainted.path()) // $ tainted=210
	sink(string: urlTainted.query()!) // $ tainted=210
	sink(string: urlTainted.user()!) // $ tainted=210

	var url1 = URL(string: clean)!
	if let values = try? urlClean.resourceValues(forKeys: []) {
		try! url1.setResourceValues(values)
	}
	sink(arg: url1)
	if let values = try? urlTainted.resourceValues(forKeys: []) {
		try! url1.setResourceValues(values)
	}
	sink(arg: url1) // $ tainted=210

	var url2 = URL(string: clean)!
	url2.setTemporaryResourceValue(source(), forKey: URL.URLResourceKey(""))
	sink(arg: url2) // $ tainted=383

	var url3 = URL(string: clean)!
	url3.appendPathComponent(clean)
	sink(arg: url3)
	url3.appendPathComponent(tainted)
	sink(arg: url3) // $ tainted=210

	var url4 = URL(string: clean)!
	url4.appendPathComponent(tainted, isDirectory: false)
	sink(arg: url4) // $ tainted=210

	var url5 = URL(string: clean)!
	url5.appendPathExtension(tainted)
	sink(arg: url5) // $ tainted=210

	var url6 = URL(string: clean)!
	url6.append(component: tainted)
	sink(arg: url6) // $ tainted=210

	var url7 = URL(string: clean)!
	url7.append(components: tainted)
	sink(arg: url7) // $ MISSING: tainted=210

	var url8 = URL(string: clean)!
	url8.append(components: clean, tainted)
	sink(arg: url8) // $ MISSING: tainted=210

	var url9 = URL(string: clean)!
	url9.append(path: tainted)
	sink(arg: url9) // $ tainted=210

	var url10 = URL(string: clean)!
	url10.append(queryItems: [source() as! URLQueryItem])
	sink(arg: url10) // $ MISSING: tainted=210

	sink(data: try! urlTainted.bookmarkData()) // $ tainted=210
	sink(data: try! URL.bookmarkData(withContentsOf: urlTainted)) // $ tainted=210
	sink(any: URL.resourceValues(forKeys: [], fromBookmarkData: dataTainted)!) // $ tainted=210

	sink(arg: URL.homeDirectory) // (static var, not tainted)
	sink(arg: URL.homeDirectory(forUser: clean)!)
	sink(arg: URL.homeDirectory(forUser: tainted)!) // $ tainted=210
}

func taintThroughUrlRequest() {
	let clean = URLRequest()
	let tainted = source() as! URLRequest

	sink(any: clean)
	sink(any: tainted) // $ tainted=431
	sink(any: clean.cachePolicy)
	sink(any: tainted.cachePolicy)
	sink(any: clean.httpMethod)
	sink(any: tainted.httpMethod)
	sink(any: clean.url!)
	sink(any: tainted.url!) // $ tainted=431
	sink(any: clean.httpBody!)
	sink(any: tainted.httpBody!) // $ tainted=431
	sink(any: clean.httpBodyStream!)
	sink(any: tainted.httpBodyStream!) // $ tainted=431
	sink(any: clean.mainDocument)
	sink(any: tainted.mainDocument) // $ tainted=431
	sink(any: clean.mainDocumentURL!)
	sink(any: tainted.mainDocumentURL!) // $ tainted=431
	sink(any: clean.allHTTPHeaderFields!)
	sink(any: tainted.allHTTPHeaderFields!) // $ tainted=431
	sink(any: clean.timeoutInterval)
	sink(any: tainted.timeoutInterval)
	sink(any: clean.httpShouldHandleCookies)
	sink(any: tainted.httpShouldHandleCookies)
	sink(any: clean.httpShouldUsePipelining)
	sink(any: tainted.httpShouldUsePipelining)
	sink(any: clean.allowsCellularAccess)
	sink(any: tainted.allowsCellularAccess)
	sink(any: clean.allowsConstrainedNetworkAccess)
	sink(any: tainted.allowsConstrainedNetworkAccess)
	sink(any: clean.allowsExpensiveNetworkAccess)
	sink(any: tainted.allowsExpensiveNetworkAccess)
	sink(any: clean.networkServiceType)
	sink(any: tainted.networkServiceType)
	sink(any: clean.attribution)
	sink(any: tainted.attribution)
	sink(any: clean.description)
	sink(any: tainted.description) // $ tainted=431
	sink(any: clean.debugDescription)
	sink(any: tainted.debugDescription) // $ tainted=431
	sink(any: clean.customMirror)
	sink(any: tainted.customMirror)
	sink(any: clean.hashValue)
	sink(any: tainted.hashValue)
	sink(any: clean.assumesHTTP3Capable)
	sink(any: tainted.assumesHTTP3Capable)
	sink(any: clean.requiresDNSSECValidation)
	sink(any: tainted.requiresDNSSECValidation)
}

func taintThroughUrlResource() {
	let clean = URLResource(name: "")
	let tainted = source() as! URLResource

	sink(string: clean.name)
	sink(string: tainted.name) // $ tainted=483
	sink(string: clean.subdirectory!)
	sink(string: tainted.subdirectory!) // $ tainted=483
}

func taintUrlAsync() async throws {
	let tainted = source() as! String
	let urlTainted = URL(string: tainted)!

	sink(any: urlTainted.lines) // $ tainted=492

	for try await line in urlTainted.lines {
		sink(string: line) // $ MISSING: tainted=492
	}
}

func closureReturnValue() {
	let url = URL(string: "http://example.com/")!

	let r1 = url.withUnsafeFileSystemRepresentation({
		ptr in
		return "abc"
	})
	sink(string: r1)

	let r2 = url.withUnsafeFileSystemRepresentation({
		ptr in
		return source() as! String
	})
	sink(string: r2) // $ tainted=513
}
