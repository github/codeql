import kotlin.reflect.KClass

annotation class Annot0k(@get:JvmName("a") val abc: Int = 0)

annotation class Annot1k(
    val a: Int = 2,
    val b: String = "ab",
    val c: KClass<*> = X::class,
    val d: Y = Y.A,
    val e: Array<Y> = [Y.A, Y.B],
    val f: Annot0k = Annot0k(1)
)

class X {}
enum class Y {
    A,B,C
}

@Annot0k(abc = 1)
@Annot1k(d = Y.B, e = arrayOf(Y.C, Y.A))
@Annot0j(abc = 1)
@Annot1j(d = Y.B, e = arrayOf(Y.C, Y.A))
class Z {}

fun fn(a: Annot0k) {
    println(a.abc)
}

