class C2 {
    fun taint(t: String): String {
        return t
    }

    fun sink(a: Any?) {}
    fun test() {
        val l = arrayOf(taint("a"), "")
        sink(l)
        sink(l[0])
        for (i in l.indices) {
            sink(l[i])
        }
        for (s in l) {
            sink(s)
        }
    }
}
