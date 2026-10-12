func t1() {
    let x = source("t1.1")
    let y = TestType.identityFlow(x)
    sink(y)  // $ hasValueFlow=t1.1
}
