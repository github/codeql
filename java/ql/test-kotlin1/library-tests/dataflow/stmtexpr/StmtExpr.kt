class StmtExpr {
    fun test() {
        val t = object : Source {
            override fun a() {
            }
        }
        sink(t) // $ hasValueFlow
    }

    fun sink(t : Source) {}

}

interface Source {
    fun a()
}