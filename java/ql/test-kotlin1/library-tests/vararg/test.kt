
fun sink(sunk: Int) {

}

open class HasVarargConstructor {

  constructor(vararg xs: Int) {
    sink(xs[xs[0]])
  }

  constructor(x: String, vararg xs: Int) : this(*xs) { }

}

class SuperclassHasVarargConstructor(x: Int) : HasVarargConstructor(x) {

}

fun funWithOnlyVarArgs(vararg xs: Int) {
    sink(xs[xs[0]])
}

fun funWithArgsAndVarArgs(x: String, y: Boolean, vararg xs: Int) {
    sink(xs[xs[0]])
}

fun funWithMiddleVarArgs(x: String, vararg xs: Int, y: Boolean) {
    sink(xs[xs[0]])
}

fun myFun() {
    val xs = listOf(10, 11, 12)
    val array = intArrayOf(100, 101, 102)
    funWithOnlyVarArgs(20, 21, 22)
    funWithArgsAndVarArgs("foo", true, 30, 31, 32)
    funWithMiddleVarArgs("foo", 41, 42, 43, y = true)
    funWithOnlyVarArgs(*array)
    funWithArgsAndVarArgs("foo", true, *array)
    funWithMiddleVarArgs("foo", *array, y = true)
    HasVarargConstructor(51, 52, 53)
    HasVarargConstructor("foo", 61, 62, 63)
    SuperclassHasVarargConstructor(91)
    HasVarargConstructor(*array)
    HasVarargConstructor("foo", *array)
}

open class X(
    i: Int,
    public vararg val s: String
) { }

fun fn(sl: List<String>) {
    // reordered args:
    val x = X(s = sl.toTypedArray(), i = 1)
}
