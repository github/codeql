package foo.bar

fun <S> Int.f0(s: S): S {
    return s
}

fun <S> Int.f1(s: S): C0<S>? {
    return null
}

open class C0<V> {}

class C1<T, W>(val t: T) : C0<W>() {
    fun f1(t: T) {}
    fun <U> f2(u: U): C1<U, U> {
        return C1<U, U>(u)
    }
}

class C2() {
    fun <P> f4(p: P) {}
}

fun m() {
    val c1 = C1<Int, Int>(1)
    c1.f1(2)
    val x1 = c1.f2("")
    val c2 = C1<String, Int>("")
    c2.f1("a")
    val x2 = c2.f2(3)
    val c3 = C2()
    c3.f4(5)
    val c4: C0<*> = C0<Int>()
}