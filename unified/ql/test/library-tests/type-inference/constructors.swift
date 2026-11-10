class C1 {
    init(_ x: Int) {}  // name=C1.init

    convenience init() {  // name=C1.init_conv
        self.init(0)  // $ target=C1.init $ SPURIOUS: target=C1.init_conv
    }
}

var c11 = C1()  // $ type=c11:C1 target=C1.init_conv $ SPURIOUS: target=C1.init
var c12 = C1.init()  // $ type=c12:C1 target=C1.init_conv $ SPURIOUS: target=C1.init

class C2: C1 {}  // inherits `init`

var c21 = C2()  // $ type=c21:C2 target=C1.init_conv $ SPURIOUS: target=C1.init
var c22 = C2.init()  // $ target=C1.init_conv type=c22:C2 $ SPURIOUS: target=C1.init

class C3 {
    init() {}
}

var c3 = C3()  // $ type=c3:C3 target=C3.init

class C4: C3 {
    init(_ x: Int) {
        super.init()  // $ target=C3.init
    }

    override convenience init() {  // name=C4.init_conv
        self.init(0)  // $ target=C4.init $ SPURIOUS: target=C4.init_conv
    }
}

class C5: C4 {}  // inherits `init` and `convenience init`

var c51 = C5()  // $ type=c51:C5 target=C4.init_conv $ SPURIOUS: target=C4.init
var c52 = C5(0)  // $ type=c52:C5 target=C4.init $ SPURIOUS: target=C4.init_conv

class C6<T1, T2> {
    init(x: T1, y: T2) {}

    private init(s: String) {}  // name=C6.init_private

    convenience init(x: T1) {  // name=C6.init_conv
        fatalError("Convenience initializer not implemented")
    }
}

class C7<T3, T4>: C6<T4, T3> {}  // inherits `init(x: T4, y: T3)` and `convenience init(x: T4)`

var c71 = C7(x: "string", y: true)  // $ type=c71@C7<T3>:Bool type=c71@C7<T4>:String target=C6.init $ SPURIOUS: target=C6.init_conv
var c72 = C7<Bool, _>(x: 0)  // $ type=c72@C7<T3>:Bool type=c72@C7<T4>:Int target=C6.init_conv $ SPURIOUS: target=C6.init

class C8: C7<Int, String> {  // inherits `init(x: String, y: Int)`
    convenience init(x: String) {  // name=C8.init_conv
        self.init(x: x, y: 0)  // $ target=C6.init $ SPURIOUS: target=C8.init_conv
    }
}

class C9<T9>: C8 {}

let c91: C9<Int> = C9(x: "")  // $ type=C9(...)@C9<T9>:Int target=C8.init_conv $ SPURIOUS: target=C6.init
let c92 = C9<Int>(x: "")  // $ type=C9<...>(...)@C9<T9>:Int target=C8.init_conv $ SPURIOUS: target=C6.init

class C10<T10a, T10b>: C6<T10a, [T10b]> {}

let c10: C10<_, Int> = C10(x: "")  // $ target=C6.init_conv $ SPURIOUS: target=C6.init $ MISSING: type=C10(...)@C10<T10b>:Int -- we currently incorrectly conclude that a type argument has been supplied for `C6.T2`, which means contextual inference is disabled

struct S1<T> {  // implicit `init(f1: T, f2: String = "default", f3: (T) -> T = { $0 })`
    var f1: T
    var f2: String = "default"
    var f3: (T) -> T = { $0 }
}

var s11 = S1(f1: 0)  // $ target=S1.init type=s11@S1<T>:Int
var s12 = S1(f1: true, f2: "")  // $ target=S1.init type=s12@S1<T>:Bool
S1(f1: 0, f2: "", f3: { x in x })  // $ target=S1.init type=x:Int
S1(f1: 0, f3: { x in x })  // $ target=S1.init $ MISSING: type=x:Int (optional parameters are not handled)

enum E1 {
    case a(Int)

    static func foo() {
        let e1 = a(0)  // $ target=E1.a type=e1:E1
    }
}

enum E2<A, B> { case a(A) }

let e2: E2<_, String> = E2.a(1)  // $ target=E2.a type=.a(...)@E2<B>:String
