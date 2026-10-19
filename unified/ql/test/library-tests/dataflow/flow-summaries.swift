func t1() {
    let x = source("t1.1")
    let y = TestType.identityFlow(x)
    sink(y)  // $ hasValueFlow=t1.1
}

func t2() {
    let x = source("t2.1")
    let array = TestType.storeArray(x)
    for let y in array {
        sink(y)  // $ hasValueFlow=t2.1
    }
}

func t3() {
    let array = [source("t3.1"), source("t3.2")]
    let y = TestType.readArray(array)
    sink(y)  // $ hasValueFlow=t3.1 hasValueFlow=t3.2
}

func t4() {
    class Box {
        var outputField: String = ""
    }
    let x = source("t4.1")
    let box = Box()
    sink(box.outputField)
    let y = TestType.postUpdateArg(x, output: box)
    sink(box.outputField)  // $ hasValueFlow=t4.1
}

func t5() {
    let x = source("t5.1")
    let y = TestType.storeUnusualName(x)
    let z = TestType.readUnusualName(y)
    sink(z)  // $ hasValueFlow=t5.1
}

func t6() {
    let x = source("t6.1")
    TestType.intoCallback(x) { y in
        sink(y)  // $ hasValueFlow=t6.1
    }
}

func t7() {
    let y = TestType.outOfCallback {
        return source("t7.1")
    }
    sink(y)  // $ hasValueFlow=t7.1
}

func t8() {
    sink(TestType.throughCallback(source("t8.1")) { y in return y })  // $ hasValueFlow=t8.1
    sink(TestType.throughCallback(source("t8.2")) { y in return y + "x" })  // $ hasTaintFlow=t8.2
    sink(TestType.throughCallback("safe") { y in return y })  // no flow
    sink(TestType.throughCallback(source("t8.3")) { y in return "safe" })  // no flow
}

func t9() {
    sink(TestType.taintFlow(source("t9.1")))  // $ hasTaintFlow=t9.1
}

func t10() {
    var x = source("t10.1")
    var y = source("t10.2")
    sink(x)  // $ hasValueFlow=t10.1
    sink(y)  // $ hasValueFlow=t10.2
    TestType.swap(&x, &y)
    sink(x)  // $ MISSING: hasValueFlow=t10.2 SPURIOUS: hasValueFlow=t10.1
    sink(y)  // $ MISSING: hasValueFlow=t10.1 SPURIOUS: hasValueFlow=t10.2
}
