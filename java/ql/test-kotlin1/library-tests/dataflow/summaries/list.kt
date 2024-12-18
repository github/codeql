class ListFlowTest {
    fun <T> taint(t: T) = t
    fun sink(a: Any) {}

    fun test(l: MutableList<String>) {
        l[0] = taint("a")
        sink(l)             // $ hasTaintFlow=a
        sink(l[0])          // $ hasValueFlow=a
        for (s in l) {
            sink(s)         // $ hasValueFlow=a
        }

        val a = arrayOf(taint("b"), "c")
        sink(a)             // $ hasTaintFlow=b
        sink(a[0])          // $ hasValueFlow=b
        for (s in a) {
            sink(s)         // $ hasValueFlow=b
        }
    }
}
