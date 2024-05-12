package k

interface A<T> {
    fun foo(t: T)
}

class B : A<String> {
    override fun foo(t: String) {}
}