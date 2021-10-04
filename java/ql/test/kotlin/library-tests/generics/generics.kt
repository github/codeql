package foo.bar

fun <S> Int.f(s: S): S {
    return s
}

class C1<T>(val t: T) {
    fun f1(t: T) {}
    fun <U> f2(u: U) {}
}
