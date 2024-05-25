open class X {
    private val a = 1
    protected val b = 2
    internal val c = 3
    val d = 4 // public by default

    protected class Nested {
        public val e: Int = 5
    }

    fun fn1(): Any {
        return object {
            fun fn() {}
        }
    }

    fun fn2() {
        fun fnLocal() {}
        fnLocal()
    }

    fun fn3() {
        class localClass {}
    }

    inline fun fn4(noinline f: () -> Unit) { }
    inline fun fn5(crossinline f: () -> Unit) { }
    inline fun <reified T> fn6(x: T) {}
}

class Y<in T1, out T2> {
    fun foo(t: T1) : T2 = null!!
}

public class LateInit {
    private lateinit var test0: LateInit

    fun fn() {
        lateinit var test1: LateInit
    }
}