func source() -> Int { return 0; }
func sink(arg: Int) {}

func intraprocedural_with_local_flow() -> Void {
    var t2: Int
    var t1: Int = source()
    sink(arg: t1)
    t2 = t1
    sink(arg: t1)
    sink(arg: t2)
    if(t1 != 0) {
        t2 = 0
        sink(arg: t2)
    }
    sink(arg: t2)

    t1 = 0;
    while(false) {
        t1 = t2
    }
    sink(arg: t1)
}

func caller_source() -> Void {
    callee_sink(x: source(), y: 1)
    callee_sink(x: 1, y: source())
}

func callee_sink(x: Int, y: Int) -> Void {
    sink(arg: x)
    sink(arg: y)
}

func callee_source() -> Int {
    return source()
}

func caller_sink() -> Void {
    sink(arg: callee_source())
}

func branching(b: Bool) -> Void {
    var t1: Int = source()
    var t: Int = 0
    if(b) {
        t = t1;
    } else {
        t = 1;
    }
    sink(arg: t)
}

func inoutSource(arg: inout Int) -> Void {
    arg = source()
}

func inoutUser() {
    var x: Int = 0
    sink(arg: x)
    inoutSource(arg: &x)
    sink(arg: x)
}