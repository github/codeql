class C {
    fun self1() = this
    fun fn1(o: C) = o

    fun Int.fn3(o: C) = o
    fun Int.fn4() = this@C

    fun call1(o: C) = 1.fn3(o)
    fun call2() = 1.fn4()
}

fun C.self2() = this
fun C.fn2(o: C) = o

class Test {
    fun <T> taint(t: T) = t
    fun sink(a: Any) {}

    fun test(s1: String) {
        val tainted = taint(C())

        sink(C().self1())
        sink(tainted.self1())

        sink(C().self2())
        sink(tainted.self2())

        sink(C().fn1(C()))
        sink(C().fn1(tainted))

        sink(C().fn2(C()))
        sink(C().fn2(tainted))

        sink(C().call1(C()))
        sink(C().call1(tainted))

        sink(C().call2())
        sink(tainted.call2())
    }
}
