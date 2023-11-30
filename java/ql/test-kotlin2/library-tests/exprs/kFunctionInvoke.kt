import kotlin.reflect.*

class A {
    fun f(s: String) { }
}

fun useRef(a: A, s: String) {
    val toCall: KFunction1<String, Unit> = a::f
    toCall(s)
}
