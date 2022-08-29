fun interface Predicate {
    fun go(s: String): String
}

class SamConversion {
    fun test() {
        val p1 = Predicate { Helper.taint() }
        val p2 = Predicate { it -> it }

        Helper.sink(p1.go(""))
        Helper.sink(p1.go(Helper.taint()))
    }
}
