// --- stubs ---

class Data {
    init<S>(_ elements: S) {}
}

struct URL {
	init?(string: String) {}
}

// A `MyContainer` contains `Data` in something rather like a `Sequence`.
struct MyContainer {
	init() { }
	init(data: Data) { }
	init(data: Data, flags: Int) { }

	mutating func append(_ data: Data) { }
	mutating func insert(_ data: Data, at: Int) { }
	func appending(_ data: Data) -> MyContainer { return self }
	func inserting(_ data: Data, at: Int) -> MyContainer { return self }

	mutating func append(contentsOf other: MyContainer) { }
	mutating func insert(contentsOf other: MyContainer, at: Int) { }
	func appending(contentsOf other: MyContainer) -> MyContainer { return self }
	func inserting(contentsOf other: MyContainer, at: Int) -> MyContainer { return self }

	mutating func append(_ string: String) { }
	mutating func append(contentsOf array: Array<Data>) { }

	subscript(index: Int) -> Data { return Data(0) }
}

// --- tests ---

func source(_ label: String) -> Data { return Data(0) }
func sourceString(_ label: String) -> String { return "" }
func sink(arg: Any) {}

// ---

func testCustom() {
	let clean = MyContainer(data: Data(0))
	let tainted = MyContainer(data: source("data1"))
	let tainted2 = MyContainer(data: source("data2"), flags: 123)
	sink(arg: clean)
	sink(arg: clean[0])
	sink(arg: tainted) // $ tainted=data1
	sink(arg: tainted[0]) // $ tainted=data1
	sink(arg: tainted2) // $ tainted=data2
	sink(arg: tainted2[0]) // $ tainted=data2

	var mc1 = MyContainer()
	mc1.append(Data(0))
	sink(arg: mc1)
	sink(arg: mc1[0])
	mc1.append(source("data3"))
	sink(arg: mc1) // $ tainted=data3
	sink(arg: mc1[0]) // $ tainted=data3

	var mc2 = MyContainer()
	mc2.insert(Data(0), at: 0)
	sink(arg: mc2)
	sink(arg: mc2[0])
	mc2.insert(source("data4"), at: 0)
	sink(arg: mc2) // $ tainted=data4
	sink(arg: mc2[0]) // $ tainted=data4

	var mc3 = MyContainer()
	mc3.append(contentsOf: clean)
	sink(arg: mc3)
	sink(arg: mc3[0])
	mc3.append(contentsOf: tainted)
	sink(arg: mc3) // $ tainted=data1
	sink(arg: mc3[0]) // $ tainted=data1

	var mc4 = MyContainer()
	mc4.insert(contentsOf: clean, at: 0)
	sink(arg: mc4)
	sink(arg: mc4[0])
	mc4.insert(contentsOf: tainted, at: 0)
	sink(arg: mc4) // $ tainted=data1
	sink(arg: mc4[0]) // $ tainted=data1

	let mc5 = MyContainer()
	sink(arg: mc5.appending(Data(0)))
	sink(arg: mc5.appending(Data(0))[0])
	sink(arg: mc5.appending(source("data5"))) // $ tainted=data5
	sink(arg: mc5.appending(source("data6"))[0]) // $ tainted=data6
	sink(arg: mc5.inserting(Data(0), at: 0))
	sink(arg: mc5.inserting(Data(0), at: 0)[0])
	sink(arg: mc5.inserting(source("data7"), at: 0)) // $ tainted=data7
	sink(arg: mc5.inserting(source("data8"), at: 0)[0]) // $ tainted=data8
	sink(arg: mc5.appending(contentsOf: clean))
	sink(arg: mc5.appending(contentsOf: clean)[0])
	sink(arg: mc5.appending(contentsOf: tainted)) // $ tainted=data1
	sink(arg: mc5.appending(contentsOf: tainted)[0]) // $ tainted=data1
	sink(arg: mc5.inserting(contentsOf: clean, at: 0))
	sink(arg: mc5.inserting(contentsOf: clean, at: 0)[0])
	sink(arg: mc5.inserting(contentsOf: tainted, at: 0)) // $ tainted=data1
	sink(arg: mc5.inserting(contentsOf: tainted, at: 0)[0]) // $ tainted=data1
	sink(arg: mc5)

	let taintedString = sourceString("data9")
	var mc6 = MyContainer()
	mc6.append("")
	sink(arg: mc6)
	sink(arg: mc6[0])
	mc6.append(taintedString)
	sink(arg: mc6) // $ tainted=data9
	sink(arg: mc6[0]) // $ tainted=data9

	let taintedArray = [source("data10")]
	var mc7 = MyContainer()
	mc7.append(contentsOf: [])
	sink(arg: mc7)
	sink(arg: mc7[0])
	mc7.append(contentsOf: taintedArray)
	sink(arg: mc7) // $ MISSING: tainted=data10
	sink(arg: mc7[0]) // $ MISSING: tainted=data10
}
