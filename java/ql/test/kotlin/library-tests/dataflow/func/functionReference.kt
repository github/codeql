class FunctionReference {

    fun fn1(s: String) = s

    fun test() {
        fun fn2(s: String) = s

        Helper.sink(Processor().process(this::fn1, Helper.taint()))
        Helper.sink(Processor().process(FunctionReference::fn1, this, Helper.taint()))
        Helper.sink(Processor().process(this::fn1, Helper.notaint()))
        Helper.sink(Processor().process(::fn2, Helper.taint()))
        Helper.sink(Processor().process(::fn2, Helper.notaint()))

        Helper.sink(Processor().process(this::prop))
    }

    val prop: String
        get() = Helper.taint()
}
