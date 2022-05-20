
class Foo {
    val prop: Int = 1

    fun myFunction(param: Int) {
        val local1 = 2 + 3
        println(local1)
        var local2 = 2 + 3
        println(local2)
        val local3 = param
        println(local3)
    }
}

val topLevel: Int = 1

class C1 {
    fun f1() {}
    fun f2() {}
}
class C2 (val o:C1) {
    fun f1() {}
    fun f3() {}

    fun f4() {
        o.ext();
    }
    fun C1.ext() {
        f1() // calls method defined in C1 class
        f2()
        f3()
        this.f1() // extensionReceiverParameter
        this.f2() // extensionReceiverParameter

        // calls method defined in C2 class
        this@C2.f1() // dispatchReceiverParameter
        this@C2.f3() // dispatchReceiverParameter
    }
}

class C3 {
    fun f0() {}
    inner class C4 {
        fun f0() {}
        fun f1() {
            this.f0()
            this@C3.f0()
        }
    }
}