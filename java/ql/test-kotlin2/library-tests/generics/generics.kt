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

class BoundedTest<T : CharSequence, S : T> {

    fun m(s: S, t: T) { }

}

class Outer<T1, T2> {
    inner class Inner1<T3, T4> {
        fun fn1(t1: T1, t2: T2, t3: T3, t4: T4) {
            val c = Inner1<Int, String>()
        }
    }

    class Nested1<T3, T4> {
        fun fn2(t3: T3, t4: T4) {
            val c = Nested1<Int, String>()
        }
    }
}

class Class1<T1> {
    fun <T2> fn1(t: T2) {
        class Local<T3> {
            fun <T4> fn2(t2: T2, t4: T4) {}
        }
        Local<Int>().fn2(t, "")
    }
}

// Diagnostic Matches: % Found more type arguments than parameters: foo.bar.Class1  ...while extracting a enclosing class (fn1) at %generics.kt:57:5:62:5%
