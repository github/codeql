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

func nested_in_statement_context() {
    #if DEBUG
        #if EXTRA
            let value = 0
        #else
            let value = 1
        #endif
    #else
        let value = 2
    #endif
}
