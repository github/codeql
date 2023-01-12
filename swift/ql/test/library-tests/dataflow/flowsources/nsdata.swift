// --- stubs ---

struct URL
{
	init?(string: String) {}
}

class NSData {
    struct ReadingOptions : OptionSet { let rawValue: Int }
    init?(contentsOf: URL) {}
    init?(contentsOf: URL, options: NSData.ReadingOptions) {}
}

// --- tests ---

func testNSData() {
    let url = URL(string: "http://example.com/")
    let _ = try NSData(contentsOf: url!) // SOURCE
    let _ = try NSData(contentsOf: url!, options: []) // SOURCE
}
