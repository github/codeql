func t1() {
    let x = source("t1.1")
    let y = TestType.identityFlow(x)
    sink(y)  // $ MISSING: hasValueFlow=t1.1
}
