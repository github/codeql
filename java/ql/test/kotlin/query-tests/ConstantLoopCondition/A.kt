fun fn0(f: Function0<Unit>) = f()

fun fn1() {
    var c = true
    while (c) {
        fn0 {
            c = false
        }
    }
}
