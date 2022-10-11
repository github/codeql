
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
	var standardized: String { get {return ""} }
	var standardizedFileURL: URL { get {return URL(string: "")!} }
	var user: String? { get {return nil} }
	var password: String? { get {return nil} }
}

class Data
{
    init<S>(_ elements: S) {}
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

func source() -> String { return "" }
func sink(arg: URL) {}
func sink(data: Data) {}
func sink(string: String) {}
func sink(int: Int) {}

func taintThroughURL() {
	let clean = "http://example.com/"
	let tainted = source()
	let urlClean = URL(string: clean)!
	let urlTainted = URL(string: tainted)!

	sink(arg: urlClean)
	sink(arg: urlTainted) // $ tainted=57
	sink(arg: urlTainted.absoluteURL) // $ tainted=57
	sink(arg: urlTainted.baseURL) // $ tainted=57
	sink(string: urlTainted.fragment!) // $ tainted=57
	sink(string: urlTainted.host!) // $ tainted=57
	sink(string: urlTainted.lastPathComponent) // $ tainted=57
	sink(string: urlTainted.path) // $ tainted=57
	sink(string: urlTainted.pathComponents[0]) // $ tainted=57
	sink(string: urlTainted.pathExtension) // $ tainted=57
	sink(int: urlTainted.port!) // $ tainted=57
	sink(string: urlTainted.query!) // $ tainted=57
	sink(string: urlTainted.relativePath) // $ tainted=57
	sink(string: urlTainted.relativeString) // $ tainted=57
	sink(string: urlTainted.scheme!) // $ tainted=57
	sink(string: urlTainted.standardized) // $ tainted=57
	sink(arg: urlTainted.standardizedFileURL) // $ tainted=57
	sink(string: urlTainted.user!) // $ tainted=57
	sink(string: urlTainted.password!) // $ tainted=57

	sink(arg: URL(string: clean, relativeTo: nil)!)
	sink(arg: URL(string: tainted, relativeTo: nil)!) // $ tainted=57
	sink(arg: URL(string: clean, relativeTo: urlClean)!)
	sink(arg: URL(string: clean, relativeTo: urlTainted)!) // $ tainted=57

	if let x = URL(string: clean) {
		sink(arg: x)
	}

	if let y = URL(string: tainted) {
		sink(arg: y) // $ MISSING: tainted=57
	}

	var urlClean2 : URL!
	urlClean2 = URL(string: clean)
	sink(arg: urlClean2)

	var urlTainted2 : URL!
	urlTainted2 = URL(string: tainted)
	sink(arg: urlTainted2) // $ tainted=57

	let task = URLSession.shared.dataTask(with: urlTainted) { (data, response, error) in
  	sink(data: data!) // $ tainted=57
	}
}
