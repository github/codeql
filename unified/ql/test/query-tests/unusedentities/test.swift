func t1() -> Int {
    let a = 1 // $ Alert[unified/unused-variable]
    let b = 2
    return b
}

func t2() -> Int {
    func foo(callback: (Int) -> Void) -> String {
        callback()
        return "df"
    }
    // Note: This currently fails because the trailing closure is not extracted correctly
    let a = 1 // $ SPURIOUS: Alert
    print(foo() { _ in
        print(a)
        let b = 2 // $ MISSING: Alert[unified/unused-variable]
    })
}
