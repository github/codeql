class Foo {
    fun f(i: Int) {}
    fun g(i: Int) { (this::f)(i) }
}
