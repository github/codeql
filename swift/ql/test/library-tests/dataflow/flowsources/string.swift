
// --- stubs ---

struct URL
{
	init?(string: String) {}
}

extension String {
	init(contentsOf: URL) throws {
		var data = ""

		// ...

		self.init(data)
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
	} catch {
		// ...
	}
}
