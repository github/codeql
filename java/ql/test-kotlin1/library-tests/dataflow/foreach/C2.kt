class C2 {
    fun taint(t: String): String {
        return t
    }

    fun sink(a: Any?) {}
    fun test() {
        val l = arrayOf(taint("a"), "")
        sink(l)
        sink(l[0])
        sink(l.get(0))
        for (i in l.indices) {
            sink(l[i])
        }
        for (s in l) {
            sink(s)
        }
    }

    fun test2() {
        val l1 = arrayOf("")
        val l2 = arrayOf("")
        l1[0] = taint("a")
        l2.set(0, taint("a"))
        sink(l1[0])
        sink(l2[0])
        sink(l1.get(0))
        sink(l2.get(0))
    }

    fun setWrapper(l: Array<String>, v: String) {
        l.set(0, v)
    }
    fun test3() {
        val l = arrayOf("")
        setWrapper(l, taint("a"))
        sink(l[0])
        sink(l.get(0))
    }
}
