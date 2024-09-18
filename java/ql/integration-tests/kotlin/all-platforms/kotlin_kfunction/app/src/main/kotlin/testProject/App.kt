import kotlin.reflect.*

fun fn() {
    val ref: KFunction2<Ccc, Int, Double> = Ccc::m
    ref.invoke(Ccc(), 1)
}

class Ccc {
    fun m(i:Int):Double = 5.0
}
