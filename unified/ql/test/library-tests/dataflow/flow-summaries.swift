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
