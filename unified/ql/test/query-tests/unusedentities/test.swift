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
    let a = 1
    print(foo() { _ in
        print(a)
        let b = 2 // $ Alert[unified/unused-variable]
    })
}
