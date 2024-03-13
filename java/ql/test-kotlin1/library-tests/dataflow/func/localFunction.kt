class LocalFunction {
    suspend fun test() {
        fun fn1() = Helper.taint()
        fun fn2(s: String) = s

        Helper.sink(fn1())
        Helper.sink(fn2(Helper.taint()))

        suspend fun fn3() = Helper.taint()
        suspend fun fn4(s: String) = s

        Helper.sink(fn3())
        Helper.sink(fn4(Helper.taint()))
    }
}
