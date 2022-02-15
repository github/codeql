fun main(b: Boolean) {
    val isEven = IntPredicate { it % 2 == 0 }

    val i0 = InterfaceFn1 { a, b -> Unit }
    val i1 = InterfaceFn1(::fn2)

    val i = InterfaceFnExt1 { i -> this == ""}

    val x = IntPredicate(if (b) {
        j -> j % 2 == 0
    } else {
        j -> j % 2 == 1
    })
}

fun interface IntPredicate {
    fun accept(i: Int): Boolean
}

fun fn2(i: Int, j: Int) { }

fun interface InterfaceFn1 {
    fun fn1(i: Int, j: Int)
}

fun interface InterfaceFnExt1 {
    fun String.ext(i: Int): Boolean
}
