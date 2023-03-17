
class NSObject
{
}

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
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
}

class Data
{
    init<S>(_ elements: S) {}
}

class InputStream {}

struct Mirror {}

typealias TimeInterval = Double

struct URLRequest {
	enum CachePolicy { case none }
	enum NetworkServiceType { case none }
	enum Attribution { case none }
	var cachePolicy: CachePolicy = .none
	var httpMethod: String = ""
	var url: URL = URL(string: "")!
	var httpBody: Data = Data("")
	var httpBodyStream: InputStream? = nil
	var mainDocument: URL = URL(string: "")!
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

class URLResponse : NSObject {}

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
	sink(arg: urlTainted) // $ tainted=91
	// Fields
	sink(arg: urlTainted.absoluteURL) // $ tainted=91
	sink(arg: urlTainted.baseURL) // $ SPURIOUS: $ tainted=91
	sink(string: urlTainted.fragment!) // $ tainted=91
	sink(string: urlTainted.host!) // $ tainted=91
	sink(string: urlTainted.lastPathComponent) // $ tainted=91
	sink(string: urlTainted.path) // $ tainted=91
	sink(string: urlTainted.pathComponents[0]) // $ tainted=91
	sink(string: urlTainted.pathExtension) // $ tainted=91
	sink(int: urlTainted.port!) // $ tainted=91
	sink(string: urlTainted.query!) // $ tainted=91
	sink(string: urlTainted.relativePath) // $ tainted=91
	sink(string: urlTainted.relativeString) // $ tainted=91
	sink(string: urlTainted.scheme!) // $ tainted=91
	sink(arg: urlTainted.standardized) // $ tainted=91
	sink(arg: urlTainted.standardizedFileURL) // $ tainted=91
	sink(string: urlTainted.user!) // $ tainted=91
	sink(string: urlTainted.password!) // $ tainted=91

	sink(arg: URL(string: clean, relativeTo: nil)!)
	sink(arg: URL(string: tainted, relativeTo: nil)!) // $ tainted=91
	sink(arg: URL(string: clean, relativeTo: urlClean)!)
	// Fields (assuming `clean` was a relative path instead of a full URL)
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.absoluteURL) // $ tainted=91
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.baseURL) // $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.fragment!) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.host!) // $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.lastPathComponent) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.path) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.pathComponents[0]) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.pathExtension) // $ SPURIOUS: $ tainted=91
	sink(int: URL(string: clean, relativeTo: urlTainted)!.port!) // $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.query!) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.relativePath) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.relativeString) // $ SPURIOUS: $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.scheme!) // $ tainted=91
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.standardized) // $ tainted=91
	sink(arg: URL(string: clean, relativeTo: urlTainted)!.standardizedFileURL) // $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.user!) // $ tainted=91
	sink(string: URL(string: clean, relativeTo: urlTainted)!.password!) // $ tainted=91

	if let x = URL(string: clean) {
		sink(arg: x)
	}

	if let y = URL(string: tainted) {
		sink(arg: y) // $ tainted=91
	}

	var urlClean2 : URL!
	urlClean2 = URL(string: clean)
	sink(arg: urlClean2)

	var urlTainted2 : URL!
	urlTainted2 = URL(string: tainted)
	sink(arg: urlTainted2) // $ tainted=91

	let task = URLSession.shared.dataTask(with: urlTainted) { (data, response, error) in
  	sink(data: data!) // $ tainted=91
	}
}

func taintThroughUrlRequest() {
	let clean = URLRequest()
	let tainted = source() as! URLRequest

	sink(any: clean)
	sink(any: tainted) // $tainted=161
	sink(any: clean.cachePolicy)
	sink(any: tainted.cachePolicy)
	sink(any: clean.httpMethod)
	sink(any: tainted.httpMethod)
	sink(any: clean.url)
	sink(any: tainted.url) // $tainted=161
	sink(any: clean.httpBody)
	sink(any: tainted.httpBody) // $tainted=161
	sink(any: clean.httpBodyStream)
	sink(any: tainted.httpBodyStream) // $tainted=161
	sink(any: clean.mainDocument)
	sink(any: tainted.mainDocument) // $tainted=161
	sink(any: clean.allHTTPHeaderFields)
	sink(any: tainted.allHTTPHeaderFields) // $tainted=161
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
	sink(any: tainted.description)
	sink(any: clean.debugDescription)
	sink(any: tainted.debugDescription)
	sink(any: clean.customMirror)
	sink(any: tainted.customMirror)
	sink(any: clean.hashValue)
	sink(any: tainted.hashValue)
	sink(any: clean.assumesHTTP3Capable)
	sink(any: tainted.assumesHTTP3Capable)
	sink(any: clean.requiresDNSSECValidation)
	sink(any: tainted.requiresDNSSECValidation)
}