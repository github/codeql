class C1 {
    init(_ x: Int) {}  // name=C1.init

    convenience init() {  // name=C1.init_conv
        self.init(0)  // $ target=C1.init $ SPURIOUS: target=C1.init_conv
    }
}

var c11 = C1()  // $ type=c11:C1 target=C1.init_conv $ SPURIOUS: target=C1.init
var c12 = C1.init()  // $ type=c12:C1 target=C1.init_conv $ SPURIOUS: target=C1.init
