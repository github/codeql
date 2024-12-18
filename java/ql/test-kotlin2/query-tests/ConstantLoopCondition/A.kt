fun fn0(f: Function0<Unit>) = f()

fun fn1() {
    var c = true
    while (c) { // TODO: false positive
        fn0 {
            c = false
        }
    }

    var d = true
    while (d) {
        fn0 {
            println(d)
        }
    }

    val e = true
    while (e) {
        fn0 {
            println(e)
        }
    }
}
