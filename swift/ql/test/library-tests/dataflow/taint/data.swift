
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
	sink(arg: dataTainted) // tainted [NOT DETECTED]
	sink(arg: dataTainted2) // tainted [NOT DETECTED]

	let stringClean = String(data: dataClean, encoding: String.Encoding.utf8)
	let stringTainted = String(data: dataTainted, encoding: String.Encoding.utf8)

	sink2(arg: stringClean!) // tainted [NOT DETECTED]
	sink2(arg: stringTainted!) // tainted [NOT DETECTED]
}
