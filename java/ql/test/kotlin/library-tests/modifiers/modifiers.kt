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
}
