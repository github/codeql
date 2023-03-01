
// --- stubs ---

struct URL {
	init?(string: String) {}
}

class NSObject {
}

class NSString : NSObject {
  init(string aString: String) {}

  convenience init?(contentsOfFile path: String) { self.init(string: "") }
  convenience init(contentsOfFile path: String, encoding enc: UInt) throws { self.init(string: "") }
  convenience init(contentsOfFile path: String, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init(string: "") }
  convenience init?(contentsOf url: URL) { self.init(string: "") }
  convenience init(contentsOf url: URL, encoding enc: UInt) throws { self.init(string: "") }
  convenience init(contentsOf url: URL, usedEncoding enc: UnsafeMutablePointer<UInt>?) throws { self.init(string: "") }

  class func string(withContentsOfFile path: String) -> Any? { return nil }
  class func string(withContentsOf url: URL) -> Any? { return nil }
}

// --- tests ---

func testNSStrings() {
	do
	{
		let path = "file.txt"
		let string1 = try NSString(contentsOfFile: path) // $ $ source=local
		let string2 = try NSString(contentsOfFile: path, encoding: 0) // $ source=local
		let string3 = try NSString(contentsOfFile: path, usedEncoding: nil) // $ source=local
		let string4 = NSString.string(withContentsOfFile: path) // $ source=local

		let url = URL(string: "http://example.com/")!
		let string5 = try NSString(contentsOf: url) // $ source=remote
		let string6 = try NSString(contentsOf: url, encoding: 0) // $ source=remote
		let string7 = try NSString(contentsOf: url, usedEncoding: nil) // $ source=remote
		let string8 = NSString.string(withContentsOf: url) // $ source=remote
	} catch {
		// ...
	}
}
