class C1 {}  // implicit parameterless `init`

class C2: C1 {}  // inherits `init`

class C3 {
    init() {}
}

class C4: C3 {
    init(_ x: Int) {
        super.init()
    }

    override convenience init() {
        self.init(0)
    }
}

class C5: C4 {}  // inherits `init` and `convenience init`

class C6<T1, T2> {
    init(x: T1, y: T2) {}

    private init(s: String) {}

    convenience init(x: T1) {
        fatalError("Convenience initializer not implemented")
    }
}

class C7<T3, T4>: C6<T4, T3> {}  // inherits `init(x: T4, y: T3)` and `convenience init(x: T4)`

class C8: C7<Int, String> {  // inherits `init(x: String, y: Int)`
    convenience init(x: String) {
        self.init(x: x, y: 0)
    }
}

struct S1 {  // implicit `init(f1: Int = 0, f2: String, f4: Double, f6: Double, f7: Double = 0)`
    var f1: Int = 0
    var f2: String
    let f3: Bool = false
    let f4: Double
    static var f5: Float = 0.0
    var f6: Double {  // todo: unlike `f7`, this is not extracted as a `VariableDeclaration`
        willSet {
            print("Changing from \(f6) to \(newValue)")
        }
        didSet {
            print("Changed from \(oldValue) to \(f6)")
        }
    }
    var f7: Double = 0.0 {
        willSet {
            print("Changing from \(f7) to \(newValue)")
        }
        didSet {
            print("Changed from \(oldValue) to \(f7)")
        }
    }
}
