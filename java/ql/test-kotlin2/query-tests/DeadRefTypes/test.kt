private class C1 { }

private class C2 { }

fun fn() {
    val c = C2()
}

fun fn1() = 5

fun fn2(f: () -> Unit) = f()

fun adapted() {
    fn2(::fn1)
}
