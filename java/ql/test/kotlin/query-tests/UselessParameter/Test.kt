interface A<T, V> {
    fun setValue(a: T, b: V)
}

class B : A<B, Int> {
    override fun setValue(a: B, b: Int) {
        println("a")
    }
}

fun fn(a: Int = 10) {}

class C {
    companion object {}
}

object O {}

fun C.fn() {}
fun C.Companion.fn() {}
fun O.fn() {}
