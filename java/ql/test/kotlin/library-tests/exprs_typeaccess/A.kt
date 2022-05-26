
class A {
    class C<T> {
        fun fn(){
            val a = C<C<Int>>()
        }
    }

    constructor() {
        println("")
    }

    val prop = this.fn(1)

    fun fn() {}
    fun fn(i: C<C<Int>>) = i
    fun fn(i: Int) : Int {
        val x = this.fn(1)
        val e = Enu.A
        return B.x
    }

    enum class Enu {
        A, B, C
    }
}
