func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

enum E {
    case case1(String)
    case case2(String)
}

func t1() {
    let e = E.case1(source("t1.1"))
    sink(e)  // no flow
    switch e {
    case E.case1(let x):
        sink(x)  // $ hasValueFlow=t1.1
    default:
        break
    }
}

func t2() {
    let e = E.case1(source("t2.1"))
    sink(e)  // no flow
    switch e {
    case .case1(let x):  // use leading-dot syntax
        sink(x)  // $ hasValueFlow=t2.1
    default:
        break
    }
}

func t3() {
    let e = E.case1(source("t3.1"))
    guard case E.case1(let x) = e else { return }
    sink(x)  // $ hasValueFlow=t3.1
}

func t4() {
    let e = E.case2(source("t4.1"))
    switch e {
    case E.case1(let x):
        sink(x)  // no flow
    case E.case2(let x):
        sink(x)  // $ hasValueFlow=t4.1
    }
    // same but in opposite match order
    switch e {
    case E.case2(let x):
        sink(x)  // $ hasValueFlow=t4.1
    case E.case1(let x):
        sink(x)  // no flow
    }
}

func t5() {
    let opt_x = Optional.some(source("t5.1"))
    guard let x = opt_x else { return }
    sink(x)  // $ hasValueFlow=t5.1
}

func t6() {
    let opt_x = Optional.some(source("t6.1"))
    guard let opt_x else { return }
    sink(opt_x)  // $ hasValueFlow=t6.1
}

enum OptionalLabel {
    case foo(x: String)
}

func t7() {
    let e = OptionalLabel.foo(x: source("t7.1"))
    switch e {
    case .foo(let x):
        sink(x)  // $ hasValueFlow=t7.1
    default:
        break
    }
    // Note: swift-format will try to remove the 'x:' label in the call below
    // swift-format-ignore
    switch e {
    case .foo(x: let x):
        sink(x)  // $ hasValueFlow=t7.1
    default:
        break
    }
}
