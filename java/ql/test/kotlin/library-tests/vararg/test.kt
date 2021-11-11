
fun funWithOnlyVarArgs(vararg xs: Int) {
}

fun funWithArgsAndVarArgs(x: String, y: Boolean, vararg xs: Int) {
}

fun funWithMiddleVarArgs(x: String, vararg xs: Int, y: Boolean) {
}

fun myFun() {
    val xs = listOf(10, 11, 12)
    funWithOnlyVarArgs(20, 21, 22)
    funWithArgsAndVarArgs("foo", true, 30, 31, 32)
    funWithMiddleVarArgs("foo", 41, 42, 43, y = true)
}

