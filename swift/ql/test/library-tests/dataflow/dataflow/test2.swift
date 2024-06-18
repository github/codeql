func source(_ label: String) -> String { return ""; }
func sink(arg: String) {}

func testDicts() {
    let d1 = ["a": "apple", "b": "banana", "c": source("source1")]
    let strA = "a"
    let strB = "b"
    let strC = "c"

    sink(arg: d1["a"]!) // $ SPURIOUS: flow=source1
    sink(arg: d1["b"]!) // $ SPURIOUS: flow=source1
    sink(arg: d1["c"]!) // $ flow=source1

    sink(arg: d1[strA]!) // $ SPURIOUS: flow=source1
    sink(arg: d1[strB]!) // $ SPURIOUS: flow=source1
    sink(arg: d1[strC]!) // $ flow=source1

    for key in d1.keys {
        sink(arg: key)
        sink(arg: d1[key]!) // $ flow=source1
    }
    for value in d1.values {
        sink(arg: value) // $ MISSING: flow=source1
    }
    for (key, value) in d1 {
        sink(arg: key)
        sink(arg: value) // $ flow=source1
    }
}

func testDicts2() {
    let d2 = [1: "one", 2: source("source2"), 3: "three"]

    sink(arg: d2[1]!) // $ SPURIOUS: flow=source2
    sink(arg: d2[2]!) // $ flow=source2
    sink(arg: d2[3]!) // $ SPURIOUS: flow=source2

    sink(arg: d2[1 + 1]!) // $ flow=source2
}

func testDicts3() {
    var d3: [String: String] = [:]

    sink(arg: d3["val"] ?? "default")

    d3["val"] = source("source3")

    sink(arg: d3["val"] ?? "default") // $ flow=source3
    sink(arg: d3["val"]!) // $ flow=source3

    d3["val"] = nil

    sink(arg: d3["val"] ?? "default") // $ SPURIOUS: flow=source3
    sink(arg: d3["val"]!) // $ SPURIOUS: flow=source3
}

func testDicts4() {
    var d4: [String: String] = [:]

    d4[source("source4")] = "value"

    for key in d4.keys {
        sink(arg: key) // $ MISSING: flow=source4
        sink(arg: d4[key]!)
    }
    for value in d4.values {
        sink(arg: value)
    }
    for (key, value) in d4 {
        sink(arg: key) // $ flow=source4
        sink(arg: value)
    }
}
