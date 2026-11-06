#if DEBUG
    let first = 1
    let second = 2
    #if EXTRA
        func f() {}
    #elseif OTHER
    #else
        let third = 3
    #endif
#else
#endif

protocol P {
    #if DEBUG
        associatedtype T
    #endif
}

func use() {
    #if DEBUG
        let value = 1
    #else
        let value = 2
    #endif
    if true {
        let nested = 3
    }
}
