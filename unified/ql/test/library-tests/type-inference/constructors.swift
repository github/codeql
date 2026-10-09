class C1 {
    init(_ x: Int) {}  // name=C1.init

    convenience init() {  // name=C1.init_conv
        self.init(0)  // $ target=C1.init $ SPURIOUS: target=C1.init_conv
    }
}

var c11 = C1()  // $ type=c11:C1 target=C1.init_conv $ SPURIOUS: target=C1.init
var c12 = C1.init()  // $ type=c12:C1 target=C1.init_conv $ SPURIOUS: target=C1.init

struct S1<T> {  // implicit `init(f1: T, f2: String = "default", f3: (T) -> T = { $0 })`
    var f1: T
    var f2: String = "default"
    var f3: (T) -> T = { $0 }
}

var s11 = S1(f1: 0)  // $ target=S1.init type=s11@S1<T>:Int
var s12 = S1(f1: true, f2: "")  // $ target=S1.init type=s12@S1<T>:Bool
S1(f1: 0, f2: "", f3: { x in x })  // $ target=S1.init type=x:Int
