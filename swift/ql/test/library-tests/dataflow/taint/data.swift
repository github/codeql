
class Data
{
    init<S>(_ elements: S) {}
}

func source() -> String { return "" }
func sink(arg: Data) {}
func sink2(arg: String) {}

func taintThroughData() {
	let dataClean = Data("123456".utf8)
	let dataTainted = Data(source().utf8)
	let dataTainted2 = Data(dataTainted)

	sink(arg: dataClean)
	sink(arg: dataTainted) // $ MISSING: tainted=13
	sink(arg: dataTainted2) // $ MISSING: tainted=13

	let stringClean = String(data: dataClean, encoding: String.Encoding.utf8)
	let stringTainted = String(data: dataTainted, encoding: String.Encoding.utf8)

	sink2(arg: stringClean!) // $ MISSING: tainted=13
	sink2(arg: stringTainted!) // $ MISSING: tainted=13
}
