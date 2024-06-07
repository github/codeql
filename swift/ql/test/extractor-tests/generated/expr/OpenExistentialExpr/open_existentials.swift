protocol P {
    func foo() -> ()
}

class C : P {
    func foo() {}
}

func createP() -> P {
    return C()
}

func test() {
    createP().foo()
}
