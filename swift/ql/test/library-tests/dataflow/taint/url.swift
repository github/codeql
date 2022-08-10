
class URL
{
	init?(string: String) {}
	init?(string: String, relativeTo: URL?) {}
}

func source() -> String { return "" }
func sink(arg: URL) {}

func taintThroughURL() {
	let clean = "http://example.com/"
	let tainted = source()
	let urlClean = URL(string: clean)!
	let urlTainted = URL(string: tainted)!

	sink(arg: urlClean)
	sink(arg: urlTainted) // tainted

	sink(arg: URL(string: clean, relativeTo: nil)!)
	sink(arg: URL(string: tainted, relativeTo: nil)!) // tainted
	sink(arg: URL(string: clean, relativeTo: urlClean)!)
	sink(arg: URL(string: clean, relativeTo: urlTainted)!) // tainted

	if let x = URL(string: clean) {
		sink(arg: x)
	}

	if let y = URL(string: tainted) {
		sink(arg: y) // tainted [NOT DETECTED]
	}

	var urlClean2 : URL!
	urlClean2 = URL(string: clean)
	sink(arg: urlClean2)

	var urlTainted2 : URL!
	urlTainted2 = URL(string: tainted)
	sink(arg: urlTainted2) // tainted
}
