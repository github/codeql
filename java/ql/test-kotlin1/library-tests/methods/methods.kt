
fun topLevelMethod(x: Int, y: Int) {
}

class Class {
    fun classMethod(x: Int, y: Int) {
    }

    fun anotherClassMethod(a: Int, b: Int) {
        classMethod(a, 3)
        topLevelMethod(b, 4)
    }

    public fun publicFun() {}
    protected fun protectedFun() {}
    private fun privateFun() {}
    internal fun internalFun() {}
    fun noExplicitVisibilityFun() {}
    inline fun inlineFun() {}
}

