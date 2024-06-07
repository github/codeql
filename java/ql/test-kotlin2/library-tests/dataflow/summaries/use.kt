import java.io.Closeable

class UseFlowTest {
    fun <T> taint(t: T) = t
    fun sink(s: Closeable) { }

    fun test(input: Closeable) {
        taint(input).use { it -> sink(it) } // $ hasValueFlow
        sink(taint(input).use { it }) // $ hasValueFlow
    }
}
