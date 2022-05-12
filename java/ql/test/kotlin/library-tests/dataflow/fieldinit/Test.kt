class Foo {
    val prop: String = "src"

    fun bar() {
       sink(prop)
    }
}

fun sink(s: String) {}