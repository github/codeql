class ApplyFlowTest {
    fun <T> taint(t: T) = t
    fun sink(s: String) { }

    fun test(input: String) {
        taint(input).apply { sink(this) } // $ hasValueFlow
        sink(taint(input).apply { this }) // $ hasValueFlow
    }
}
