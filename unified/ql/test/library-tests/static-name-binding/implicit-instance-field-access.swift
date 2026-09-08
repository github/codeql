private class A {
    let x = 123 // name=A.instance.x

    func getX() {
        return x // $ access=A.instance.x
    }
}

private class B : A { // $ access=A
    func getX2() {
        return x // $ access=A.instance.x
    }
}
