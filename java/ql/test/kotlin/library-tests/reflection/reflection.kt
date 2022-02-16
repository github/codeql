import kotlin.reflect.KFunction2

class Reflection {
    fun fn(boo: Boolean) {
        val ref: KFunction2<Ccc, Int, Double> = Ccc::m
        println(ref.name)
    }

    class Ccc {
        fun m(i:Int):Double = 5.0
    }
}