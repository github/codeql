private class A {
    let x = 123 // name=A.instance.x

    func getX() {
        return self.x // not handled by static name binding
    }

    static let y = 456 // name=A.type.y

    func getY1() {
        return Self.y // $ access=A access=A.type.y
    }

    static func getY2() {
        return self.y // $ not handled by static name binding
    }

    class func z() -> Int { // name=A.type.z
        return 789
    }

    class func getZ() {
        return self.z // $ not handled by static name binding
    }
}

private class B : A { // $ access=A
    func getX2() {
        return self.x // not handled by static name binding
    }

    func getY3() {
        return Self.y // $ access=B access=A.type.y
    }

    static func getY4() {
        return self.y // $ not handled by static name binding
    }

    class func z() -> Int { // name=B.type.z
        return 789
    }

    class func getZ2() {
        return self.z // $ not handled by static name binding
    }
}

private class C {
    static let x = 1
    class D {
        static let x = 2
        static let foo = Self.x // $ access=C.D access=C.D.x $ SPURIOUS: access=C.x
    }
}
