class ListFlowTest {
    fun <T> taint(t: T) = t
    fun sink(a: Any) {}

    fun test(l: MutableList<String>) {
        l[0] = taint("a")
        sink(l)
        sink(l[0])
        for (s in l) {
            sink(s)
        }

        val a = arrayOf(taint("a"), "b")
        sink(a)
        sink(a[0])
        for (s in a) {
            sink(s)
        }
    }
}
