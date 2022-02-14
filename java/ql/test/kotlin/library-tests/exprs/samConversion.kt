fun main() {
    val isEven = IntPredicate { it % 2 == 0 }

    InterfaceFn1 { a, b -> Unit }.fn1(1,2)

    val i = InterfaceFnExt1 { i -> this == ""}
}

fun interface IntPredicate {
    fun accept(i: Int): Boolean
}

fun interface InterfaceFn1 {
    fun fn1(i: Int, j: Int)
}

fun interface InterfaceFnExt1 {
    fun String.ext(i: Int): Boolean
}
