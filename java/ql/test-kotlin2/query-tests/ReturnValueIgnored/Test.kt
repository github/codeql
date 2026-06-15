class Foo {
    fun foo(): Int { return 5 }
    fun bar() {
        val x0 = foo()
        val x1 = foo()
        val x2 = foo()
        val x3 = foo()
        val x4 = foo()
        val x5 = foo()
        val x6 = foo()
        val x7 = foo()
        val x8 = foo()
        val x9 = foo()
        val x = if (true) { foo() } else 6
    }
}
