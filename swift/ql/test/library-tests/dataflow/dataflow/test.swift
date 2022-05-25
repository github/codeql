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
    callee_sink(x: source())
}

func callee_sink(x: Int) -> Void {
    sink(arg: x)
}

func callee_source() -> Int {
    return source()
}

func caller_sink() -> Void {
    sink(arg: callee_source())
}
