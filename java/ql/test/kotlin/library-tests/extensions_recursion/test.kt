
fun <T> Foo<T>.bar(): Boolean {
    return true
}

class Foo<T> {
    fun foo(): Boolean {
        return bar()
    }
}

