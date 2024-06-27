
// --- stubs ---

struct URL {
	init?(string: String) {}
}

class MyClass {
	init(contentsOfFile: String) { }
	init(contentsOfFile: String?, options: [Int]) { }
	init(contentsOf: URL, fileTypeHint: Int) { }

	init(contentsOfPath: String) { }
	init(contentsOfDirectory: String) { }

	func append(contentsOf: String) { }
	func appending(contentsOf: String) -> MyClass { return self }
}

// --- tests ---

func testCustom() {
	let url = URL(string: "http://example.com/")!

	let x = MyClass(contentsOfFile: "foo.txt") // $ source=local
	_ = MyClass(contentsOfFile: "foo.txt", options: []) // $ source=local
	_ = MyClass(contentsOf: url, fileTypeHint: 1) // $ source=remote

	_ = MyClass(contentsOfPath: "/foo/bar") // $ source=local
	_ = MyClass(contentsOfDirectory: "/foo/bar") // $ source=local

	x.append(contentsOf: "abcdef") // (not a flow source)
	_ = x.appending(contentsOf: "abcdef") // (not a flow source)
}
