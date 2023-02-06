func foo() -> Int {
    return 42
}

func bar(_ x: Int, d y: Double) -> Int {
    return x + Int(y)
}

protocol Beep {
    func noBody(x: Int) -> Int
}

func variadic(_ ints: Int...) {
    print(ints)
}

func generic<X, Y>(x: X, y: Y) {
    print(x, y)
}
