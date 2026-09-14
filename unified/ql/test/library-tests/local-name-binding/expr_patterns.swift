func t1() {
    let a = 0 // name=a1
    let b = 1 // name=b1
    switch 1 {
        case a + b: // $ access=a1 access=b1
            a; // $ access=a1
            b; // $ access=b1
            break
        default:
            break
    }
}

func t2() {
    let b = 1 // name=b1
    class M {
        static let b = 1
    }
    switch 1 {
        case let M.b: // $ access=M
            b; // $ access=b1
            break
        default:
            break
    }
}

func t3() {
    let b = 1 // name=b1
    class M {
        static let b = 1
    }
    switch 1 {
        case let true ? M.b : M.b: // $ access=M
            b; // $ access=b1
            break
        default:
            break
    }
}
