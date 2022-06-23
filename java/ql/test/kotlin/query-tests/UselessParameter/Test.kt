interface A<T, V> {
    fun setValue(a: T, b: V)
}

class B : A<B, Int> {
    override fun setValue(a: B, b: Int) {
        println("a")
    }
}
