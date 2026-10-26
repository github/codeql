// --- stubs ---

struct URL
{
	init?(string: String) {}
}


struct Data {
    struct ReadingOptions : OptionSet { let rawValue: Int }
	init(contentsOf: URL, options: ReadingOptions) {}
}

// --- tests ---

func testData() {
    let url = URL(string: "http://example.com/")
    let data = try Data(contentsOf: url!, options: []) // $ source=remote
}
