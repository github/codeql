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
