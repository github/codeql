func basic_patterns() {
    var an_int = 42
    var a_string: String = "here"
    let (x, y, z) = (1, 2, 3)
    let _ = "any"
    let (_) = "paren"
}

func switch_patterns() {
    let point = (1, 2)
    switch point {
    case let (xx, yy): "binding"
    }

    switch 3 {
    case 1 + 2: "expr"
    case _: ""
    }

    enum Foo {
        case bar, baz(Int, String)
    }

    let v: Foo = .bar

    switch v {
    case .bar: "bar"
    case let .baz(i, s): i
    }

    let w: Int? = nil

    switch w {
    case let n?: n
    case _: "none"
    }

    let a: Any = "any"

    switch a {
    case is Int: "is pattern"
    case let x as String: "as pattern"
    case _: "other"
    }

    let b = true

    switch b {
    case true: "true"
    case false: "false"
    }
}

func bound_and_unbound() {
    let a = 1, b = 2, c: Int = 3

    if let (a, b, c) = Optional.some((a, b, c)) { _ = (a, c) }
    if case (a, let b, let c) = (a, b, c) { _ = (b) }

    switch a {
        case c: "equals c"
        case let c: "binds c"
        default: "default"
    }
}

func source() -> Int { 0 }
func sink(arg: Int) { }

indirect enum MyEnum {
    case myNone
    case mySingle(Int)
    case myPair(Int, Int)
    case myCons(Int, MyEnum)
}

func test_enums() {
    var a : MyEnum = .myNone

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    a = .mySingle(source())

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    a = MyEnum.myPair(0, source())

    switch a {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = a {
        sink(arg: x)
    }
    if case .myPair(let x, let y) = a {
        sink(arg: x)
        sink(arg: y)
    }

    let b: MyEnum = .myCons(42, a)

    switch b {
    case .myNone:
        ()
    case .mySingle(let a):
        sink(arg: a)
    case .myPair(let a, let b):
        sink(arg: a)
        sink(arg: b)
    case let .myCons(a, .myPair(b, c)):
        sink(arg: a)
        sink(arg: b)
        sink(arg: c)
    case let .myCons(a, _):
        sink(arg: a)
    }

    if case .mySingle(let x) = MyEnum.myPair(source(), 0) {
        sink(arg: x)
    }
    if case MyEnum.myPair(let x, let y) = .myPair(source(), 0) {
        sink(arg: x)
        sink(arg: y)
    }
    if case let .myCons(_, .myPair(_, c)) = b {
        sink(arg: c)
    }

    switch (a, b) {
    case let (.myPair(a, b), .myCons(c, .myPair(d, e))):
        sink(arg: a)
        sink(arg: b)
        sink(arg: c)
        sink(arg: d)
        sink(arg: e)
    default:
        ()
    }
}
