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

fun interface BigArityPredicate {
    fun accept(i0: Int, i1: Int, i2: Int, i3: Int, i4: Int, i5: Int, i6: Int, i7: Int, i8: Int, i9: Int,
               i10: Int, i11: Int, i12: Int, i13: Int, i14: Int, i15: Int, i16: Int, i17: Int, i18: Int, i19: Int,
               i20: Int, i21: Int, i22: Int): Boolean
}

fun ff(i0: Int, i1: Int, i2: Int, i3: Int, i4: Int, i5: Int, i6: Int, i7: Int, i8: Int, i9: Int,
       i10: Int, i11: Int, i12: Int, i13: Int, i14: Int, i15: Int, i16: Int, i17: Int, i18: Int, i19: Int,
       i20: Int, i21: Int, i22: Int): Boolean = true

fun fn(boo: Boolean) {
    val a = ::ff
    val b = BigArityPredicate(a)
    val c = BigArityPredicate {i0: Int, i1: Int, i2: Int, i3: Int, i4: Int, i5: Int, i6: Int, i7: Int, i8: Int, i9: Int,
                               i10: Int, i11: Int, i12: Int, i13: Int, i14: Int, i15: Int, i16: Int, i17: Int, i18: Int, i19: Int,
                               i20: Int, i21: Int, i22: Int -> true}
    val d = SomePredicate<Int> { a -> true }
}

fun interface SomePredicate<T> {
    fun fn(i: T): Boolean
}

fun interface InterfaceFn1Sus {
    suspend fun fn1(i: Int, j: Int)
}

suspend fun test() {
    val i0 = InterfaceFn1Sus { a, b -> Unit }
    i0.fn1(1,2)
}

class PropertyRefsTest {
    val x = 1
}

fun interface PropertyRefsGetter {
    fun f(prt: PropertyRefsTest): Int
}

fun interface IntGetter {
    fun f(): Int
}

fun propertyRefsTest(prt: PropertyRefsTest) {
    val test1 = IntGetter(prt::x)
    val test2 = PropertyRefsGetter(PropertyRefsTest::x)
}
