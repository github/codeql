import kotlin.reflect.*

class Reflection {
    fun fn() {
        val ref: KFunction2<Ccc, Int, Double> = Ccc::m
        println(ref.name)

        val x0: KProperty1<C, Int> = C::p0
        val x1: Int = x0.get(C())
        val x2: String = x0.name
        val x3: KProperty1.Getter<C, Int> = x0.getter
        val x4: KFunction1<C, Int> = x0::get
        val x5: KProperty0<Int> = C()::p0

        val y0: KMutableProperty1<C, Int> = C::p1
        val y1: Unit = y0.set(C(), 5)
        val y2: String = y0.name
        val y3: KMutableProperty1.Setter<C, Int> = y0.setter
        val y4: KFunction2<C, Int, Unit> = y0::set
        val y5: KMutableProperty0<Int> = C()::p1

        val prop = (C::class).members.single { it.name == "p3" } as KProperty2<C, Int, Int>
        val z0 = prop.get(C(), 5)
    }

    class Ccc {
        fun m(i:Int):Double = 5.0
    }

    class C {
        val p0: Int = 1
        var p1: Int = 2
        var p2: Int
            get() = 1
            set(value) = Unit

        var Int.p3: Int         // this can't be referenced through a property reference
            get() = 1
            set(value) = Unit
    }
}


val String.lastChar: Char
    get() = this[length - 1]

fun fn2() {
    println(String::lastChar.get("abc"))
    println("abcd"::lastChar.get())
}
