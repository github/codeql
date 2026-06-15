class WithFlowTest {
    fun <T> taint(t: T) = t
    fun sink(s: String) { }

    fun test(input: String) {
        with(taint(input)) { sink(this) } // $ hasValueFlow
        sink(with(taint(input)) { this }) // $ hasValueFlow
    }
}
