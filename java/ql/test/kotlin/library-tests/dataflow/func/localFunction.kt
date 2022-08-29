class LocalFunction {
    fun test() {
        fun fn1() = Helper.taint()
        fun fn2(s: String) = s

        Helper.sink(fn1())
        Helper.sink(fn2(Helper.taint()))
    }
}
