
class NSObject
{
}

struct URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
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

func taintThroughURL() {
	let clean = "http://example.com/"
	let tainted = source()
	let urlClean = URL(string: clean)!
	let urlTainted = URL(string: tainted)!

	sink(arg: urlClean)
	sink(arg: urlTainted) // $ tainted=39

	sink(arg: URL(string: clean, relativeTo: nil)!)
	sink(arg: URL(string: tainted, relativeTo: nil)!) // $ tainted=39
	sink(arg: URL(string: clean, relativeTo: urlClean)!)
	sink(arg: URL(string: clean, relativeTo: urlTainted)!) // $ tainted=39

	if let x = URL(string: clean) {
		sink(arg: x)
	}

	if let y = URL(string: tainted) {
		sink(arg: y) // $ MISSING: tainted=39
	}

	var urlClean2 : URL!
	urlClean2 = URL(string: clean)
	sink(arg: urlClean2)

	var urlTainted2 : URL!
	urlTainted2 = URL(string: tainted)
	sink(arg: urlTainted2) // $ tainted=39

	let task = URLSession.shared.dataTask(with: urlTainted) { (data, response, error) in
  	sink(data: data!) // $ tainted=39
	}
}
