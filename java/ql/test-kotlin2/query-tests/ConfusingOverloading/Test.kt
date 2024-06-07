class C {
    var p: Int
        get() = 1
        set(value) {}
    fun fn() {
        val prop = C::p
        prop(this)
    }
}

class A {
    fun <T : Any> fn(value: T, i: Int = 1) {}
    fun fn(value: String, i: Int = 1) {}
}

class Foo {
    val str by lazy {
        "someString"
    }
}
