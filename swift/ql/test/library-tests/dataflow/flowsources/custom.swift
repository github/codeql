
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

	let x = MyClass(contentsOfFile: "foo.txt") // $ MISSING: source=remote
	_ = MyClass(contentsOfFile: "foo.txt", options: []) // $ MISSING: source=remote
	_ = MyClass(contentsOf: url, fileTypeHint: 1) // $ MISSING: source=remote

	_ = MyClass(contentsOfPath: "/foo/bar") // $ MISSING: source=remote
	_ = MyClass(contentsOfDirectory: "/foo/bar") // $ MISSING: source=remote

	x.append(contentsOf: "abcdef") // (not a flow source)
	_ = x.appending(contentsOf: "abcdef") // (not a flow source)
}
