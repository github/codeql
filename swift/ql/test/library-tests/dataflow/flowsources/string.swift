
// --- stubs ---

struct URL
{
	init?(string: String) {}
}

extension String {
	struct Encoding {
		var rawValue: UInt

		init(rawValue: UInt) { self.rawValue = rawValue }

		static let ascii = Encoding(rawValue: 1)
	}

	init(contentsOf url: URL) throws {
		var data = ""

		// ...

		self.init(data)
	}

	init(contentsOf url: URL, encoding enc: String.Encoding) throws {
		self.init("")
	}

	init(contentsOf url: URL, usedEncoding: inout String.Encoding) throws {
		self.init("")
	}

	init(contentsOfFile path: String) throws {
		self.init("")
	}

	init(contentsOfFile path: String, encoding enc: String.Encoding) throws {
		self.init("")
	}

	init(contentsOfFile path: String, usedEncoding: inout String.Encoding) throws {
		self.init("")
	}
}

// --- tests ---

func testStrings() {
	do
	{
		let string1 = String()
		let string2 = String(repeating: "abc", count: 10)

		let url = URL(string: "http://example.com/")
		let string3 = try String(contentsOf: url!) // SOURCE
		let string4 = try String(contentsOf: url!, encoding: String.Encoding.ascii) // SOURCE
		var encoding = String.Encoding.ascii
		let string5 = try String(contentsOf: url!, usedEncoding: &encoding) // SOURCE

		let path = "file.txt"
		let string6 = try String(contentsOfFile: path) // SOURCE
		let string7 = try String(contentsOfFile: path, encoding: String.Encoding.ascii) // SOURCE
		let string8 = try String(contentsOfFile: path, usedEncoding: &encoding) // SOURCE
	} catch {
		// ...
	}
}
